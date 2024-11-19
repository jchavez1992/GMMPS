#!/bin/bash

GMMPS=`pwd`

###############################################################################
# 0: Check OS
###############################################################################

OS=`scripts/discoverOS.sh`
if [ $OS = "UNSUPPORTED" ]; then
    echo " "
    echo "####################################################"
    echo "GMMPS Installer: ERROR: Unsupported operating system"
    echo "####################################################"
    echo " "
    exit
elif [ $OS = "Darwin" ]; then
    libsuffix=".dylib"
else
    libsuffix=".so"
fi

cd ${GMMPS}
echo " "
test -e bin && \rm bin
test -e lib && \rm lib
test -d bin.$OS && rm -rf bin.$OS
test -d lib.$OS && rm -rf lib.$OS
mkdir -p bin.$OS lib.$OS
ln -sf bin.$OS bin
ln -sf lib.$OS lib

###############################################################################
# 1: Get Tcl/Tk and skycat from ESO
###############################################################################

echo " "
echo "################################################################### "
echo "GMMPS Installer: Installing Tcl/Tk ... "
echo "################################################################### "
echo " "

#1a. Checking for proper x11 libraries
if [ $OS = "Darwin" ]; then
    echo "I am on a mac"   #Please remove
    export CPLUS_INCLUDE_PATH=/usr/X11/include
    export LIBRARY_PATH=/usr/X11/lib
    libext=`mdfind -name libXext.6.dylib`
    if [ ${libext}_A = "_A" ]; then
    	# If macOS 10.15, check the standard location
    	if [ ! -e $LIBRARY_PATH ]; then
        	echo "Could not find the X11 libraries."
        	echo "Please be sure that XQuartz (https://www.xquartz.org) is installed."
        	exit 1
      fi
    fi
    #Checking if current version of Xcode installed
    scripts/XcodeLicenseAccepted.sh
    if [ $? -ne 0 ]; then
      echo "ERROR: Xcode license agreement does not match current version"
      echo "Please either reinstall ('xcode-select --install')"
      echo "or accept the license ('sudo xcodebuild -license accept') "
      exit 1
    fi
else
    echo "I am on a linux"
    libext=`find '/usr' -name 'libXext.so' 2> tmp | grep -v 'Permission denied' ; rm tmp`
    if [ ${libext}_A = "_A" ]; then
        libext6=`find '/usr' -name 'libXext.so.6' 2> tmp | grep -v 'Permission denied' ; rm tmp`
        if [ ${libext6}_A != "_A" ]; then
            ln -s ${libext6} lib.${OS}/libXext.so
        else
            echo "Could not find the X11 libraries."
            echo "Please confirm that the X11 development libraries are installed."
            exit 1
        fi
    fi

    tar xfz tarfiles/tcltk-8.4.1-1.tar.gz
    cd tcltk-8.4.1/
    make prefix=${GMMPS}
    cd ${GMMPS}
fi

                                                             
echo " "
echo "####################################################### "
echo "GMMPS Installer: Installing Skycat ... "                
echo "####################################################### "
echo " "

echo "Trying to see if skycat is already installed"
skycatpath=`scripts/locate_libs.sh $OS`  #<< This is not working b/c only searches upto
                                        # version 3.1.6 of skycat libraries. eso uses 3.1.8
                                        # Also the c1-c3 conditions don't pass either.
                                        #is this really necessary for macs?
echo "echo skycatpath from locate_libs: ${skycatpath}"
if [[ ${skycatpath}_A = "_A" ]]; then
    echo "No skycatpath path found. Going to install"
    if [ $OS = "Darwin" ]; then
        #Need to be running in sudo mode. If not, ask for it now.
        if [ "$EUID" -ne 0 ]; then
            echo "Need to run as sudo. Please enter password here. . . "
	          sudo -k
	          if sudo true; then
	              echo "Thanks! Permissions granted"
	          else
	              echo "I'm sorry, we won't be able to install skcat from macports"
	              echo "www.eso.org/sci/observing/tools/skycat/skycatDownload.html"
	              exit 1
		  fi
        fi
        install_skycat_outputs=`scripts/install_skycat_mac.sh`
	echo "${install_skycat_outputs}"
	
	skycatpath=`scripts/locate_libs.sh Darwin`
	export LIBRARY_PATH=${skycatpath}
    else
        tar xfz tarfiles/skycat-3.1.4-1.tar.gz
        cd skycat-3.1.4/
        ./configure --prefix=${GMMPS}

        #CHANGES
        #make all install
        skycat_deps=("tclutil" "astrotcl" "rtd" "cat" "skycat")
        for dep in "${skycat_deps[@]}"; do
        	cd $dep
        	./configure --prefix=${GMMPS}
        	make install CXX="g++ -Wno-narrowing -fpermissive -std=c++11"
        	cd ${GMMPS}/skycat-3.1.4
        done

        cd ${GMMPS}

        export skycatpath=${GMMPS}/lib
        export LIBRARY_PATH=${skycatpath}

        sleep 1
    fi
fi

cd ${GMMPS}

sleep 1

###############################################################################
# 2: Install CFITSIO  (from macports?)
###############################################################################

 echo " "
 echo "################################################################### "
 echo "GMMPS Installer: Installing cfitsio ... "
 echo "################################################################### "
 echo " "

 sleep 1

if [ $OS = "Darwin" ]; then

    echo " "
    echo "################################################################### "
    echo "... from macports"
    echo "################################################################### "
    echo " "
    sudo port install cfitsio

else
     tar xfz tarfiles/cfitsio3410.tar.gz
    cd cfitsio
 
    ./configure | tee cfitsio.log
    success=`grep "Congratulations, Makefile update was successful." cfitsio.log`
    if [ "${success}_A" = "_A" ]; then
	    echo " "
	    echo "################################################################### "
	    echo "GMMPS Installer: ERROR! cfitsio did not configure correctly ..."
	    echo "################################################################### "
	    echo " "
	    exit
    else
	    echo " "
	    echo "################################################################### "
	    echo "GMMPS Installer: cfitsio configured fine... making"
	    echo "################################################################### "
	    echo " "
	    sleep 1
    fi
 
    make
    success=`test -f libcfitsio.a && echo success`
    if [ "${success}_A" = "_A" ]; then
	    echo " "
	    echo "################################################################### "
	    echo "GMMPS Installer: ERROR! libcfitsio.a was not created!"
	    echo "################################################################### "
	    echo " "
	    exit
    else
	    echo " "
	    echo "################################################################### "
	    echo "GMMPS Installer: libcfitsio.a created ... installing"
	    echo "################################################################### "
	    echo " "
	    sleep 1
    fi
 
    make install
    rm cfitsio.log
    make clean
fi
 
###############################################################################
# 3: Install wcstools  (from macports?)
###############################################################################

 echo " "
 echo "################################################################### "
 echo "GMMPS Installer: Installing wcstools ... "
 echo "################################################################### "
 echo " "
 
 sleep 1


 if [ $OS = "Darwin" ]; then
    echo " "
    echo "################################################################### "
    echo "... from macports"
    echo "################################################################### "
    echo " "
    sudo port install wcstools
 else
    cd ${GMMPS}/wcstools-3.9.2
    make sky2xy xy2sky
    mv bin/* ${GMMPS}/bin/
    make clean
 fi
       

###############################################################################
# 4: Setting up the system
###############################################################################

echo " "
echo "################################################################### "
echo "GMMPS Installer: Building GMMPS ..."
echo "################################################################### "
echo " "

sleep 1

if [ $OS != "Darwin" ]; then
    cd ${GMMPS}/cfitsio
    cp libcfitsio.a ../lib/ 
    cp include/*.h ../include/
fi

if [ $OS = "Darwin" ]; then
    export DYLD_LIBRARY_PATH=${GMMPS}/lib.$OS:${skycatpath}
else
    export LD_LIBRARY_PATH=${GMMPS}/lib.$OS:${skycatpath}
fi

cd ${GMMPS}/src
make clean
make

# Check if all binaries are there and executable
cd ${GMMPS}/bin/

./gmCat2Fits        | grep USAGE > log
./gmMakeMasks       | grep USAGE >> log
./gmmps_fov         | grep USAGE >> log
./gmmps_sel         | grep USAGE >> log
./gmFits2Cat        | grep USAGE >> log
./calc_throughput   | grep USAGE >> log
./get_OT_posangle   | grep USAGE >> log
./gemwm             | grep USAGE >> log
./sky2xy 2>&1       | grep Usage >> log  
./xy2sky 2>&1       | grep Usage >> log  
nsuccess=`wc -l log | awk '{print $1}'`
if [ $nsuccess != 10 ]; then
    echo " "
    echo "######################################################################### "
    echo "GMMPS Installer: ERROR: Not all GMMPS executables were built correctly!"
    echo "                 Revise the output below for errors!"
    echo "######################################################################### "
    echo " "
    cat log
    \rm log
    exit
fi
\rm log

# Do the last installation step
cd ${GMMPS}

${GMMPS}/scripts/build_gmmps ${GMMPS} $skycatpath $OS > ${GMMPS}/bin/gmmps
chmod a+x ${GMMPS}/bin/gmmps

echo
echo "########################################################################"
echo ""
echo "GMMPS modules verified. The GMMPS startup script is:"
echo "   ${GMMPS}/bin/gmmps"
echo ""
echo "Please add"
echo "   ${GMMPS}/bin/"
echo "to your PATH variable. Restart your shell and type 'gmmps' to run GMMPS."
echo ""
echo "########################################################################"
echo

# clean up  
rm -rf tcltk-8.4.1
rm -rf skycat-3.1.4
rm -rf cfitsio
