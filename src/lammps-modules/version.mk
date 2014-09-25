NAME        = lammps-modules
RELEASE     = 0
PKGROOT     = /opt/modulefiles/applications/lammps

VERSION_SRC = $(REDHAT.ROOT)/src/lammps/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
