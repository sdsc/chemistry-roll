PACKAGE     = namd
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 9
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

EXTRA_MODULE_VERSIONS = 2.9 2.12

RPM.PREFIX  = $(PKGROOT)
RPM.EXTRAS  = AutoReq:No\nAutoProv:No
