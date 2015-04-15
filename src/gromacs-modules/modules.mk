other-typical-modulefile-install:
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	for V in $(VERSION) $(EXTRA_MODULE_VERSIONS); do \
	  cp *.module $(ROOT)/$(PKGROOT)/$$V; \
	  cp *.version $(ROOT)/$(PKGROOT)/.version.$$V; \
	  perl -pi -e 's#COMPILERNAME#$(COMPILERNAME)#g;' \
	           -e 's#MPINAME#$(MPINAME)#g;' \
	           -e 's#ROLLCOMPILER#$(ROLLCOMPILER)#g;' \
	           -e 's#ROLLMPI#$(ROLLOTHERMPI)#g;' \
	           -e 's#ROLLOPTS#$(ROLLOPTS)#g;' \
	           -e 's#ROLLPY#$(ROLLPY)#g;' \
	           -e "s#VERSION#$$V#g;" \
	    $(ROOT)/$(PKGROOT)/.version.$$V $(ROOT)/$(PKGROOT)/$$V; \
	done
	ln -s $(PKGROOT)/.version.$(VERSION) $(ROOT)/$(PKGROOT)/.version
