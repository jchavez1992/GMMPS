# ------------------------------------------------------------------------
#       Makefile for BLT distribution
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
#       Source and target installation directories
# ------------------------------------------------------------------------

prefix =	/Users/joy.chavez/Desktop/Work/gmmps_add_480
exec_prefix  =	/Users/joy.chavez/Desktop/Work/gmmps_add_480
srcdir =	.
bindir =	${exec_prefix}/bin
includedir =	${prefix}/include
libdir =	/Users/joy.chavez/Desktop/Work/gmmps_add_480/lib
version =	2.4
scriptdir =	$(prefix)/lib/blt$(version)

instdirs =	$(prefix) \
		$(exec_prefix) \
		$(bindir) \
		$(libdir) \
		$(includedir) \
		$(scriptdir)

# ------------------------------------------------------------------------
#       Don't edit anything beyond this point
# ------------------------------------------------------------------------

INSTALL =	/usr/bin/install -c
INSTALL_DATA =	${INSTALL} -m 644
INSTALL_ROOT = 
SHELL =		/bin/sh
RM =		rm -f

subdirs =	src library man demos 

all:  
	(cd src; $(MAKE) all)
	(cd library; $(MAKE) all)
	(cd man; $(MAKE) all)
	(cd demos; $(MAKE) all)

install: mkdirs install-all 

install-all:
	(cd src; $(MAKE) install)
	(cd library; $(MAKE) install)
	(cd man; $(MAKE) install)
	(cd demos; $(MAKE) install)
	$(INSTALL_DATA) $(srcdir)/README $(INSTALL_DIR)$(scriptdir)
	$(INSTALL_DATA) $(srcdir)/PROBLEMS $(INSTALL_DIR)$(scriptdir)
	$(INSTALL_DATA) $(srcdir)/NEWS $(INSTALL_DIR)$(scriptdir)

mkdirs:
	@for i in $(instdirs) ; do \
          if test -d $(INSTALL_ROOT)$$i ; then \
	    : ; \
	  else \
            echo " mkdir $(INSTALL_ROOT)$$i" ; \
            mkdir $(INSTALL_ROOT)$$i ; \
          fi ; \
        done

clean:
	(cd src; $(MAKE) clean)
	(cd library; $(MAKE) clean)
	(cd man; $(MAKE) clean)
	(cd demos; $(MAKE) clean)
	$(RM) *.bak *\~ "#"* *pure* .pure*

GENERATED_FILES = \
	config.status config.cache config.log Makefile 

distclean: clean
	$(RM) $(GENERATED_FILES)
	$(RM) -rf autom4te.cache
