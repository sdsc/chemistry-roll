ifneq ("$(ROLLOPTS)", "$(subst lammps_othermpi=,,$(ROLLOPTS))")
  override ROLLMPI = $(subst lammps_othermpi=,,$(filter lammps_othermpi=%,$(ROLLOPTS)))
else ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

PACKAGE     = lammps
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 10
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.PREFIX  = $(PKGROOT)
RPM.EXTRAS  = AutoReq:No\nAutoProv:No
