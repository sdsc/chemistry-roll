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

clean::
	rm -f $(VERSION_INC)
