# E.S.O. - VLT project 
# $Id: rtdConfig.sh.in,v 1.1.1.1 2009/03/31 14:11:52 cguirao Exp $
#
# rtdConfig.sh --
# 
# This shell script (for sh) is generated automatically by Rtd's
# configure script.  It will create shell variables for most of
# the configuration options discovered by the configure script.
# This script is intended to be included by the configure scripts
# for Rtd extensions so that they don't have to figure this all
# out for themselves.  This file does not duplicate information
# already provided by tclConfig.sh, so you may need to use that
# file in addition to this one.
#
# The information in this file is specific to a single platform.

# Rtd's version number.
rtd_VERSION='3.2.1'

# The name of the Rtd library:
rtd_LIB_FILE=librtd3.2.1.dylib

# String to pass to linker to pick up the Rtd library from its
# build directory.
rtd_BUILD_LIB_SPEC='-L/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/rtd -lrtd3.2.1'

# Rtd build directory.
rtd_BUILD_DIR='/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/rtd'

# String to pass to linker to pick up the Rtd library from its
# installed directory.
rtd_LIB_SPEC='-L/Users/joy.chavez/Desktop/Work/gmmps_add_480/lib -lrtd3.2.1'

# Location of the top-level source directories from which Rtd
# was built.  This is the directory that contains generic, unix, etc.
# If Rtd was compiled in a different place than the directory
# containing the source files, this points to the location of the sources,
# not the location where Rtd was compiled.
rtd_SRC_DIR='/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/rtd'

# List of object files used to build the library (for merging packages).
rtd_PKG_OBJECTS=' ../rtd/BiasData.o ../rtd/ByteImageData.o ../rtd/ColorMapInfo.o ../rtd/CompoundImageData.o ../rtd/DoubleImageData.o ../rtd/FloatImageData.o ../rtd/ITTInfo.o ../rtd/ImageColor.o ../rtd/ImageData.o ../rtd/ImageDisplay.o ../rtd/ImageZoom.o ../rtd/LongImageData.o ../rtd/LongLongImageData.o ../rtd/LookupTable.o ../rtd/NativeImageData.o ../rtd/RtdCamera.o ../rtd/RtdCmds.o ../rtd/RtdCoords.o ../rtd/RtdHDU.o ../rtd/RtdImage.o ../rtd/RtdPerf.o ../rtd/RtdPerformanceTool.o ../rtd/RtdRPFile.o ../rtd/RtdRPTool.o ../rtd/RtdRemote.o ../rtd/RtdUtils.o ../rtd/ShortImageData.o ../rtd/UShortImageData.o ../rtd/XImageData.o ../rtd/colormaps.o ../rtd/histdist.o ../rtd/histeql.o ../rtd/histlist.o ../rtd/histmap.o ../rtd/histscan.o ../rtd/histzero.o ../rtd/iqefunc.o ../rtd/mpfit.o ../rtd/rtd_bitmaps.o ../rtd/rtd_remote.o ../rtd/saoutil.o ../rtd/rtdImageEvent.o ../rtd/rtdSem.o'

# List of header filesinstalled for this library (for merging packages).
rtd_PKG_HEADERS='@rtd_PKG_HEADERS@'
