# E.S.O. - VLT project 
# $Id: astrotclConfig.sh.in,v 1.1.1.1 2009/03/31 14:11:52 cguirao Exp $
#
# astrotclConfig.sh --
# 
# This shell script (for sh) is generated automatically by Astrotcl's
# configure script.  It will create shell variables for most of
# the configuration options discovered by the configure script.
# This script is intended to be included by the configure scripts
# for Astrotcl extensions so that they don't have to figure this all
# out for themselves.  This file does not duplicate information
# already provided by tclConfig.sh, so you may need to use that
# file in addition to this one.
#
# The information in this file is specific to a single platform.

# Astrotcl's version number.
astrotcl_VERSION='2.1.0'

# The name of the Astrotcl library:
astrotcl_LIB_FILE=libastrotcl2.1.0.dylib

# Astrotcl build directory.
astrotcl_BUILD_DIR='/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/astrotcl'

# String to pass to linker to pick up the Astrotcl library from its
# build directory.
astrotcl_BUILD_LIB_SPEC='-L/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/astrotcl -lastrotcl2.1.0'

# String to pass to linker to pick up the Astrotcl library from its
# installed directory.
astrotcl_LIB_SPEC='-L/Users/joy.chavez/Desktop/Work/gmmps_add_480/lib -lastrotcl2.1.0'

# Location of the top-level source directories from which Astrotcl
# was built.  This is the directory that contains generic, unix, etc.
# If Astrotcl was compiled in a different place than the directory
# containing the source files, this points to the location of the sources,
# not the location where Astrotcl was compiled.
astrotcl_SRC_DIR='/Users/joy.chavez/Desktop/Work/gmmps_add_480/skycat-3.1.4/astrotcl'

# List of object files used to build the library (for merging packages).
astrotcl_PKG_OBJECTS=' ../astrotcl/Astrotcl.o ../astrotcl/DCompress.o ../astrotcl/FitsIO.o ../astrotcl/HMS.o ../astrotcl/ImageCoords.o ../astrotcl/ImageIO.o ../astrotcl/SAOWCS.o ../astrotcl/TclWorldCoords.o ../astrotcl/WCSRep.o ../astrotcl/WorldCoords.o ../astrotcl/cotr.o ../astrotcl/jprec.o ../astrotcl/slasubs.o ../astrotcl/trigod.o ../astrotcl/world_coords.o ../astrotcl/digitize.o ../astrotcl/gzip.o ../astrotcl/gzip_inflate.o ../astrotcl/gzip_util.o ../astrotcl/h_decomp.o ../astrotcl/h_press.o ../astrotcl/hcomp.o ../astrotcl/hinv.o ../astrotcl/hsmooth.o ../astrotcl/htrans.o ../astrotcl/local_press.o ../astrotcl/msg.o ../astrotcl/none.o ../astrotcl/pr_msg.o ../astrotcl/press.o ../astrotcl/ulda.o ../astrotcl/undigitize.o ../astrotcl/ux_press.o ../astrotcl/cel.o ../astrotcl/dateutil.o ../astrotcl/distort.o ../astrotcl/dsspos.o ../astrotcl/fitsfile.o ../astrotcl/hget.o ../astrotcl/hput.o ../astrotcl/iget.o ../astrotcl/imhfile.o ../astrotcl/imio.o ../astrotcl/lin.o ../astrotcl/platepos.o ../astrotcl/proj.o ../astrotcl/sph.o ../astrotcl/tnxpos.o ../astrotcl/wcs.o ../astrotcl/wcscon.o ../astrotcl/wcsinit.o ../astrotcl/wcslib.o ../astrotcl/wcstrig.o ../astrotcl/worldpos.o ../astrotcl/buffers.o ../astrotcl/cfileio.o ../astrotcl/checksum.o ../astrotcl/compress.o ../astrotcl/drvrfile.o ../astrotcl/drvrmem.o ../astrotcl/drvrnet.o ../astrotcl/drvrsmem.o ../astrotcl/editcol.o ../astrotcl/edithdu.o ../astrotcl/eval_f.o ../astrotcl/eval_l.o ../astrotcl/eval_y.o ../astrotcl/fits_hcompress.o ../astrotcl/fits_hdecompress.o ../astrotcl/fitscore.o ../astrotcl/getcol.o ../astrotcl/getcolb.o ../astrotcl/getcold.o ../astrotcl/getcole.o ../astrotcl/getcoli.o ../astrotcl/getcolj.o ../astrotcl/getcolk.o ../astrotcl/getcoll.o ../astrotcl/getcols.o ../astrotcl/getcolsb.o ../astrotcl/getcolui.o ../astrotcl/getcoluj.o ../astrotcl/getcoluk.o ../astrotcl/getkey.o ../astrotcl/group.o ../astrotcl/grparser.o ../astrotcl/histo.o ../astrotcl/imcompress.o ../astrotcl/iraffits.o ../astrotcl/modkey.o ../astrotcl/pliocomp.o ../astrotcl/putcol.o ../astrotcl/putcolb.o ../astrotcl/putcold.o ../astrotcl/putcole.o ../astrotcl/putcoli.o ../astrotcl/putcolj.o ../astrotcl/putcolk.o ../astrotcl/putcoll.o ../astrotcl/putcols.o ../astrotcl/putcolsb.o ../astrotcl/putcolu.o ../astrotcl/putcolui.o ../astrotcl/putcoluj.o ../astrotcl/putcoluk.o ../astrotcl/putkey.o ../astrotcl/quantize.o ../astrotcl/region.o ../astrotcl/ricecomp.o ../astrotcl/scalnull.o ../astrotcl/swapproc.o ../astrotcl/wcssub.o ../astrotcl/wcsutil.o'

# List of header filesinstalled for this library (for merging packages).
astrotcl_PKG_HEADERS='@astrotcl_PKG_HEADERS@'
