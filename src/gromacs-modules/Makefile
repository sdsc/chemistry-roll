REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Rules.mk

$(VERSION_INC): $(VERSION_SRC)
	/bin/grep 'VERSION.*=' $(VERSION_SRC) > $@
 
build:

install:: typical-modulefile-install extra-modulefile-install

extra-modulefile-install:
	cp gromacsextra $(ROOT)/$(PKGROOT)/$(VERSION).extra

clean::
	rm -f $(VERSION_INC)
