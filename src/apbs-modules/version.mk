PACKAGE     = apbs
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 11
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
