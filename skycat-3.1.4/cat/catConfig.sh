# E.S.O. - VLT project 
# $Id: catConfig.sh.in,v 1.1.1.1 2009/03/31 14:11:52 cguirao Exp $
#
# catConfig.sh --
# 
# This shell script (for sh) is generated automatically by Cat's
# configure script.  It will create shell variables for most of
# the configuration options discovered by the configure script.
# This script is intended to be included by the configure scripts
# for Cat extensions so that they don't have to figure this all
# out for themselves.  This file does not duplicate information
# already provided by tclConfig.sh, so you may need to use that
# file in addition to this one.
#
# The information in this file is specific to a single platform.

# Cat's version number.
cat_VERSION='4.1.0'

# The name of the Cat library:
cat_LIB_FILE=libcat4.1.0.dylib

# String to pass to linker to pick up the Cat library from its
# build directory.
cat_BUILD_LIB_SPEC='-L/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/cat -lcat4.1.0'

# Cat build directory.
cat_BUILD_DIR='/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/cat'

# String to pass to linker to pick up the Cat library from its
# installed directory.
cat_LIB_SPEC='-L/Users/joy.chavez/Desktop/Work/gmmps_add_480/lib -lcat4.1.0'

# Location of the top-level source directories from which Cat
# was built.  This is the directory that contains generic, unix, etc.
# If Cat was compiled in a different place than the directory
# containing the source files, this points to the location of the sources,
# not the location where Cat was compiled.
cat_SRC_DIR='/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/cat'

# List of object files used to build the library (for merging packages).
cat_PKG_OBJECTS=' ../cat/AstroCatalog.o ../cat/AstroImage.o ../cat/AstroQuery.o ../cat/CatalogInfo.o ../cat/LocalCatalog.o ../cat/QueryResult.o ../cat/TabTable.o ../cat/TclAstroCat.o ../cat/TclAstroImage.o ../cat/TclQueryUtil.o ../cat/TclTcsCat.o ../cat/TcsCatalog.o ../cat/TcsCatalogObject.o ../cat/TcsLocalCatalog.o ../cat/TcsQueryResult.o ../cat/astro_catalog.o ../cat/astro_image.o ../cat/cat_bitmaps.o'

# List of header filesinstalled for this library (for merging packages).
cat_PKG_HEADERS='@cat_PKG_HEADERS@'
