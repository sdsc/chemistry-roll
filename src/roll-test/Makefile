REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Rules.mk

build:

install:: typical-roll-test-install
	perl -pi -e "s!CP2K_CUDAVER!$(CP2K_CUDAVER)!" $(ROOT)/$(PKGROOT)/chemistry.t
	perl -pi -e "s!CHEMISTRY_CUDA!$(CHEMISTRY_CUDA)!" $(ROOT)/$(PKGROOT)/chemistry.t
   

clean::
