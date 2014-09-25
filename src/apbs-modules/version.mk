NAME        = apbs-modules
RELEASE     = 0
PKGROOT     = /opt/modulefiles/applications/apbs

VERSION_SRC = $(REDHAT.ROOT)/src/apbs/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
