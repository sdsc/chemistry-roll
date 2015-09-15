REDHAT.ROOT = $(CURDIR)/../../


-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Rules.mk
include modules.mk

$(VERSION_INC): $(VERSION_SRC)
	/bin/grep 'VERSION.*=' $(VERSION_SRC) > $@
 

build:


ifneq ("$(ROLLOPTS)", "$(subst gromacs_othermpi,,$(ROLLOPTS))")
install:: other-typical-modulefile-install
else
install:: typical-modulefile-install
endif


clean::
	rm -f $(VERSION_INC)
