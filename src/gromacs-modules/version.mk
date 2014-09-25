NAME        = gromacs-modules
RELEASE     = 0
PKGROOT     = /opt/modulefiles/applications/gromacs

VERSION_SRC = $(REDHAT.ROOT)/src/gromacs/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
