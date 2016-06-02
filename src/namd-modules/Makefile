REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Rules.mk

$(VERSION_INC): $(VERSION_SRC)
	/bin/grep 'SOURCE_VERSION.*=' $(VERSION_SRC) > $@
	cat $@ |sed 's/SOURCE_//' >.tmp
	mv .tmp $@
 
build:

install:: typical-modulefile-install
	for V in $(VERSION) $(EXTRA_MODULE_VERSIONS); do \
	  perl -pi -e 's#ROLLCUDA#$(ROLLCUDA)#g;' \
	    $(ROOT)/$(PKGROOT)/.version.$${V} $(ROOT)/$(PKGROOT)/$${V}; \
	done

clean::
	rm -f $(VERSION_INC)
