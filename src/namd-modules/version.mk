NAME        = namd-modules
RELEASE     = 0
PKGROOT     = /opt/modulefiles/applications/namd

VERSION_SRC = $(REDHAT.ROOT)/src/namd/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
