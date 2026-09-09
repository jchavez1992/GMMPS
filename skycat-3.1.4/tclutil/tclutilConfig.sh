# E.S.O. - VLT project 
# $Id: tclutilConfig.sh.in,v 1.1.1.1 2009/03/31 14:11:52 cguirao Exp $
#
# tclutilConfig.sh --
# 
# This shell script (for sh) is generated automatically by Tclutil's
# configure script.  It will create shell variables for most of
# the configuration options discovered by the configure script.
# This script is intended to be included by the configure scripts
# for Tclutil extensions so that they don't have to figure this all
# out for themselves.  This file does not duplicate information
# already provided by tclConfig.sh, so you may need to use that
# file in addition to this one.
#
# The information in this file is specific to a single platform.

# Tclutil's version number.
tclutil_VERSION='2.1.0'

# The name of the Tclutil library:
tclutil_LIB_FILE=libtclutil2.1.0.dylib

# Tclutil build directory.
tclutil_BUILD_DIR='/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/tclutil'

# String to pass to linker to pick up the Tclutil library from its
# build directory.
tclutil_BUILD_LIB_SPEC='-L/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/tclutil -ltclutil2.1.0'

# String to pass to linker to pick up the Tclutil library from its
# installed directory.
tclutil_LIB_SPEC='-L/Users/joy.chavez/Desktop/Work/gmmps_add_480/lib -ltclutil2.1.0'

# String to pass to linker to pick up the BLT library from its
# installed directory.
BLT_LIB_SPEC='-L/Users/joy.chavez/Desktop/Work/gmmps_add_480/lib -lBLT24'

# Directory containing the BLT shared library 
# (sometimes this is installed in $prefix/lib/blt2.4 rather than $prefix/lib).
BLT_LIB_DIR='/Users/joy.chavez/Desktop/Work/gmmps_add_480/lib'

# Location of the top-level source directories from which Tclutil
# was built.  This is the directory that contains generic, unix, etc.
# If Tclutil was compiled in a different place than the directory
# containing the source files, this points to the location of the sources,
# not the location where Tclutil was compiled.
tclutil_SRC_DIR='/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/tclutil'

# List of object files used to build the library (for merging packages).
tclutil_PKG_OBJECTS=' ../tclutil/Blt_GraphElement.o ../tclutil/ErrorHandler.o ../tclutil/HTTP.o ../tclutil/Mem.o ../tclutil/Mem_Map.o ../tclutil/ShellCommand.o ../tclutil/TclCommand.o ../tclutil/Tclutil.o ../tclutil/TkImage.o ../tclutil/TkWidget.o ../tclutil/base64.o ../tclutil/error.o ../tclutil/tclutil_bitmaps.o ../tclutil/util.o'

# List of header filesinstalled for this library (for merging packages).
tclutil_PKG_HEADERS='@tclutil_PKG_HEADERS@'
