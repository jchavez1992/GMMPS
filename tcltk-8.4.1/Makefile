# Makefile

# change these to the install prefix and exec-prefix values
prefix = /usr/local
#prefix = ${HOME}/work/eso/skycat/install
exec_prefix = $(prefix)

# Tcl and extensions
TCL = tcl8.4.11
TK = tk8.4.11
TCLX = tclx8.4
ITCL = itcl3.3
IWIDGETS = iwidgets4.0.1
TKIMG = tkimg1.3
BLT = blt2.4

# run make clean in these dirs
subdirs = $(TCL)/unix $(TK)/unix $(TCLX) $(ITCL) $(IWIDGETS) $(TKIMG) $(BLT)

CONFIGURE = ./configure --prefix=$(prefix) --exec_prefix=$(exec_prefix) --enable-shared


all: tcl tk tclx itcl iwidgets tkimg blt

tcl: 
	(cd $(TCL)/unix \
	&& $(CONFIGURE) \
	&& $(MAKE) all && $(MAKE) install) || exit 1

tk:
	(cd $(TK)/unix \
	&& $(CONFIGURE) \
	&& $(MAKE) all && $(MAKE) install) || exit 1

tclx:
	(cd $(TCLX) \
	&& $(CONFIGURE) \
	&& $(MAKE) all && $(MAKE) install) || exit 1

itcl:
	(cd $(ITCL) \
	&& $(CONFIGURE) \
	&& $(MAKE) all && $(MAKE) install) || exit 1

iwidgets:
	(cd $(IWIDGETS) \
	&& $(CONFIGURE) \
	&& $(MAKE) all && $(MAKE) install) || exit 1

# Note: the first configure below is to work around a problem
# in libjpeg, where the jconfig file is not always generated 
tkimg:
	(cd $(TKIMG)/libjpeg && ./configure)
	(cd $(TKIMG) \
	&& $(CONFIGURE) \
	&& $(MAKE) EXTRA_CFLAGS="" all && $(MAKE) install) || exit 1

blt:
	(cd $(BLT) \
	&& $(CONFIGURE) \
	&& $(MAKE) all && $(MAKE) install) || exit 1

install: FORCE
	set -x; for i in $(subdirs) ; do (cd $$i && $(MAKE) install) ; done

clean: FORCE
	set -x; for i in $(subdirs) ; do (cd $$i && $(MAKE) clean) ; done

distclean: FORCE
	set -x; for i in $(subdirs) ; do (cd $$i && $(MAKE) distclean) ; done

FORCE:
