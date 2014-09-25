NAME        = cp2k-modules
RELEASE     = 0
PKGROOT     = /opt/modulefiles/applications/cp2k

VERSION_SRC = $(REDHAT.ROOT)/src/cp2k/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
