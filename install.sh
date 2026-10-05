#!/bin/bash

#====================================================================
# GMMPS Installer - Architecture Detection & Environment Setup
#====================================================================

#set -e  # Exit on error (but we'll handle it)

GMMPS=`pwd`


###############################################################################
# 0: Detect OS and Architecture
###############################################################################

echo " "
echo "################################################################### "
echo "GMMPS Installer: System Detection"
echo "################################################################### "
echo " "

OS=`scripts/discoverOS.sh`
if [ $OS = "UNSUPPORTED" ]; then
    echo "####################################################"
    echo "GMMPS Installer: ERROR: Unsupported operating system"
    echo "####################################################"
    echo " "
    exit 1
fi

# Get architecture information
SYSTEM=$(uname -s)
ARCH=$(uname -m)
KERNEL=$(uname -r)

echo "System:     $SYSTEM"
echo "Architecture: $ARCH"
echo "Kernel:     $KERNEL"
echo "GMMPS OS:   $OS"
echo " "

#====================================================================
# Architecture-Specific Configuration
#====================================================================

# Initialize flags
CFLAGS_DEFAULT="-O2"
CXXFLAGS_DEFAULT="-O2"
LDFLAGS_DEFAULT=""

case "$OS" in
    Darwin)
        libsuffix=".dylib"
        echo "Detected macOS"
        
        case "$ARCH" in
            arm64)
                echo " Apple Silicon (ARM64) detected"
                export CFLAGS="-O2 -arch arm64"
                export CXXFLAGS="-O2 -arch arm64"
                export LDFLAGS="-arch arm64"
                ;;
            x86_64)
                echo " Intel Mac (x86_64) detected"
                export CFLAGS="-O2 -arch x86_64"
                export CXXFLAGS="-O2 -arch x86_64"
                export LDFLAGS="-arch x86_64"
                ;;
            i386)
                echo " 32-bit Intel (i386) detected - may have compatibility issues"
                export CFLAGS="-O2 -arch i386"
                export CXXFLAGS="-O2 -arch i386"
                export LDFLAGS="-arch i386"
                ;;
            *)
                echo " Unknown Mac architecture: $ARCH - using default flags"
                export CFLAGS="$CFLAGS_DEFAULT"
                export CXXFLAGS="$CXXFLAGS_DEFAULT"
                export LDFLAGS="$LDFLAGS_DEFAULT"
                ;;
        esac
        
        ;;
    Linux)
        libsuffix=".so"
        echo "Detected Linux"
        export CFLAGS="$CFLAGS_DEFAULT"
        export CXXFLAGS="$CXXFLAGS_DEFAULT"
        export LDFLAGS="$LDFLAGS_DEFAULT"
        
        case "$ARCH" in
            x86_64)
                echo "  Architecture: x86_64 (64-bit)"
                ;;
            aarch64)
                echo "  Architecture: ARM64 (64-bit)"
                ;;
            armv7l)
                echo "  Architecture: ARM v7 (32-bit)"
                ;;
            *)
                echo "  Architecture: $ARCH"
                ;;
        esac
        ;;
    *)
        libsuffix=".so"
        echo "Unknown system: $OS - using default configuration"
        export CFLAGS="$CFLAGS_DEFAULT"
        export CXXFLAGS="$CXXFLAGS_DEFAULT"
        export LDFLAGS="$LDFLAGS_DEFAULT"
        ;;
esac

# Export C++ compiler as well
export CXX=${CXX:-"g++"}
export CC=${CC:-"gcc"}

echo ""
echo "Build Configuration:"
echo "  CC:       $CC"
echo "  CXX:      $CXX"
echo "  CFLAGS:   $CFLAGS"
echo "  CXXFLAGS: $CXXFLAGS"
echo "  LDFLAGS:  $LDFLAGS"
echo ""

# Verify autoconf availability for cfitsio
if command -v autoconf &> /dev/null; then
    AUTOCONF_PATH=$(which autoconf)
    echo " autoconf found at: $AUTOCONF_PATH"
else
    echo " autoconf not found - cfitsio will use pre-generated configure"
fi

echo ""

#====================================================================
# Setup directory structure
#====================================================================

cd ${GMMPS}
echo " "
test -e bin && \rm bin
test -e lib && \rm lib
test -d bin.$OS && rm -rf bin.$OS
test -d lib.$OS && rm -rf lib.$OS
mkdir -p bin.$OS lib.$OS
ln -sf bin.$OS bin
ln -sf lib.$OS lib

echo " Directory structure created"
echo " "

###############################################################################
# 2: Install CFITSIO
###############################################################################

echo " "
echo "################################################################### "
echo "GMMPS Installer: Installing cfitsio ... "
echo "################################################################### "
echo " "

sleep 1

cd cfitsio

# Regenerate configure if autoconf is available
if [ -f configure.ac ] && command -v autoconf &> /dev/null; then
    echo "Regenerating cfitsio configure script..."
    autoconf 2>/dev/null || true
fi

echo "Configuring cfitsio with architecture flags: $CFLAGS"
./configure --prefix=${GMMPS} \
    --enable-shared \
    CFLAGS="$CFLAGS" \
    CXXFLAGS="$CXXFLAGS" \
    LDFLAGS="$LDFLAGS" | tee cfitsio.log

success=`grep "Congratulations, Makefile update was successful." cfitsio.log`
if [ -z "$success" ]; then
    echo " "
    echo "################################################################### "
    echo "GMMPS Installer: ERROR! cfitsio did not configure correctly ..."
    echo "################################################################### "
    echo " "
    echo "Check cfitsio.log for details"
    exit 1
else
    echo " "
    echo "################################################################### "
    echo "GMMPS Installer: cfitsio configured fine... making"
    echo "################################################################### "
    echo " "
    sleep 1
fi

echo "Building cfitsio..."
make CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"

if [ ! -f libcfitsio.a ]; then
    echo " "
    echo "################################################################### "
    echo "GMMPS Installer: ERROR! libcfitsio.a was not created!"
    echo "################################################################### "
    echo " "
    exit 1
else
    echo " "
    echo "################################################################### "
    echo "GMMPS Installer: libcfitsio.a created ... installing"
    echo "################################################################### "
    echo " "
    sleep 1
fi

echo "Installing cfitsio..."
make install

# Verify the built library architecture
if [ $OS = "Darwin" ]; then
    echo ""
    echo "Verifying cfitsio library architecture:"
    file libcfitsio.a | head -1
    echo ""
fi

rm -f cfitsio.log
# make clean

cd ${GMMPS}

echo " cfitsio installation complete"
echo " "
 
###############################################################################
# 1: Compile Tcl/Tk and skycat
###############################################################################

echo " "
echo "################################################################### "
echo "GMMPS Installer: Installing Tcl/Tk ... "
echo "################################################################### "
echo " "

if [ $OS = "Darwin" ]; then
    export CPLUS_INCLUDE_PATH=/usr/X11/include
    export LIBRARY_PATH=/usr/X11/lib
    libext=`mdfind -name libXext.6.dylib 2>/dev/null || echo ""`
    if [ -z "$libext" ]; then
        # If macOS, check the standard location
        if [ ! -e $LIBRARY_PATH ]; then
            echo "Could not find the X11 libraries."
            echo "Please be sure that XQuartz (https://www.xquartz.org) is installed."
            exit 1
        fi
    fi
else
    libext=`find '/usr' -name 'libXext.so' 2> /dev/null || echo ""`
    if [ -z "$libext" ]; then
        libext6=`find '/usr' -name 'libXext.so.6' 2> /dev/null || echo ""`
        if [ -n "$libext6" ]; then
            ln -s ${libext6} lib.${OS}/libXext.so
        else
            echo "Could not find the X11 libraries."
            echo "Please confirm that the X11 development libraries are installed."
            exit 1
        fi
    fi
fi

echo "Building Tcl/Tk with architecture flags: $CFLAGS"
cd tcltk-8.4.1/
make prefix=${GMMPS} CFLAGS="$CFLAGS -std=gnu89 -Wno-implicit-int -Wno-implicit-function-declaration" LDFLAGS="$LDFLAGS"
if [ $? -ne 0 ]; then
    echo "ERROR: Tcl/Tk build failed"
    exit 1
fi
cd ${GMMPS}

echo " Tcl/Tk installation complete"
echo " "

echo "################################################################### "
echo "GMMPS Installer: Installing Skycat ... "
echo "################################################################### "
echo " "

cd skycat-3.1.4/

echo "Configuring Skycat components..."
skycat_deps=("tclutil" "astrotcl" "rtd" "cat" "skycat")

for dep in "${skycat_deps[@]}"; do
    echo ""
    echo "Building: $dep"
    if [ ! -d "$dep" ]; then
        echo "ERROR: Directory $dep not found"
        exit 1
    fi
    
    cd $dep
    
    # Regenerate configure if autoconf is available and configure.ac exists
    if [ -f configure.ac ] && command -v autoconf &> /dev/null; then
        echo "  Regenerating configure script..."
        autoconf 2>/dev/null || true
    fi
    
    echo "  Configuring $dep..."
    ./configure --prefix=${GMMPS} \
        CFLAGS="$CFLAGS" \
        CXXFLAGS="$CXXFLAGS" \
        LDFLAGS="$LDFLAGS" \
        CXX="g++ -Wno-narrowing -fpermissive -std=c++11"
    
    if [ $? -ne 0 ]; then
        echo "ERROR: $dep configure failed"
        exit 1
    fi
    
    echo "  Building $dep..."
    make install CXX="g++ -Wno-narrowing -fpermissive -std=c++11" \
        CFLAGS="$CFLAGS" \
        CXXFLAGS="$CXXFLAGS" \
        LDFLAGS="$LDFLAGS"
    
    if [ $? -ne 0 ]; then
        echo "ERROR: $dep make install failed"
        exit 1
    fi
    
    echo " $dep built successfully"
    cd ..
done

cd ${GMMPS}

export skycatpath=${GMMPS}/lib
export LIBRARY_PATH=${skycatpath}

echo ""
echo " Skycat installation complete"
echo " "

sleep 1

###############################################################################
# 3: Install wcstools
###############################################################################

echo " "
echo "################################################################### "
echo "GMMPS Installer: Installing wcstools ... "
echo "################################################################### "
echo " "

sleep 1

cd ${GMMPS}/wcstools-3.9.2

echo "Building wcstools with architecture flags: $CFLAGS"
make sky2xy xy2sky \
    CFLAGS="$CFLAGS" \
    CXXFLAGS="$CXXFLAGS" \
    LDFLAGS="$LDFLAGS"

if [ $? -ne 0 ]; then
    echo "ERROR: wcstools build failed"
    exit 1
fi

mv bin/* ${GMMPS}/bin/
make clean

echo " wcstools installation complete"
echo " "

###############################################################################
# 4: Setting up the system
###############################################################################

echo " "
echo "################################################################### "
echo "GMMPS Installer: Building GMMPS ... "
echo "################################################################### "
echo " "

sleep 1

cd ${GMMPS}/cfitsio
cp libcfitsio.a ../lib/
cp include/*.h ../include/

if [ $OS = "Darwin" ]; then
    export DYLD_LIBRARY_PATH=${GMMPS}/lib.$OS:${skycatpath}
else
    export LD_LIBRARY_PATH=${GMMPS}/lib.$OS:${skycatpath}
fi

echo "Building GMMPS with architecture flags: $CFLAGS"
cd ${GMMPS}/src
make clean CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"
make CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"

if [ $? -ne 0 ]; then
    echo "ERROR: GMMPS build failed"
    exit 1
fi

echo " GMMPS build complete"
echo " "

# Check if all binaries are there and executable
echo "Verifying GMMPS executables..."
cd ${GMMPS}/bin/

binaries=("gmCat2Fits" "gmMakeMasks" "gmmps_fov" "gmmps_sel" "gmFits2Cat" "calc_throughput" "get_OT_posangle" "gemwm")
missing_binaries=0

for bin in "${binaries[@]}"; do
    if [ ! -f "$bin" ] || [ ! -x "$bin" ]; then
        echo "✗ Missing or not executable: $bin"
        missing_binaries=$((missing_binaries + 1))
    else
        echo " $bin"
    fi
done

# Check wcstools binaries
for bin in "sky2xy" "xy2sky"; do
    if [ ! -f "$bin" ] || [ ! -x "$bin" ]; then
        echo "✗ Missing or not executable: $bin"
        missing_binaries=$((missing_binaries + 1))
    else
        echo " $bin"
    fi
done

if [ $missing_binaries -gt 0 ]; then
    echo " "
    echo "######################################################################### "
    echo "GMMPS Installer: ERROR: $missing_binaries executable(s) missing or not built!"
    echo "                 Revise the output above for errors!"
    echo "######################################################################### "
    echo " "
    exit 1
fi

echo ""
echo " All executables verified"
echo ""

# Do the last installation step
cd ${GMMPS}

${GMMPS}/scripts/build_gmmps ${GMMPS} $skycatpath $OS > ${GMMPS}/bin/gmmps
chmod a+x ${GMMPS}/bin/gmmps

echo ""
echo "########################################################################"
echo ""
echo "GMMPS modules verified. The GMMPS startup script is:"
echo "   ${GMMPS}/bin/gmmps"
echo ""
echo "Please add"
echo "   ${GMMPS}/bin/"
echo "to your PATH variable. Restart your shell and type 'gmmps' to run GMMPS."
echo ""
echo "Build Summary:"
echo "  System:       $SYSTEM ($ARCH)"
echo "  CFLAGS:       $CFLAGS"
echo "  CXXFLAGS:     $CXXFLAGS"
echo "  LDFLAGS:      $LDFLAGS"
echo "########################################################################"
echo ""

# clean up
rm -rf tcltk-8.4.1
rm -rf skycat-3.1.4
rm -rf cfitsio

echo " Installation complete and temporary files cleaned up"
echo ""
