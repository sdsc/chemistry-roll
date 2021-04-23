ifneq ("$(ROLLOPTS)", "$(subst gromacs_othercompiler=,,$(ROLLOPTS))")
  override ROLLCOMPILER = $(subst gromacs_othercompiler=,,$(filter gromacs_othercompiler=%,$(ROLLOPTS)))
else ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifneq ("$(ROLLOPTS)", "$(subst gromacs_othermpi=,,$(ROLLOPTS))")
  override ROLLMPI = $(subst gromacs_othermpi=,,$(filter gromacs_othermpi=%,$(ROLLOPTS)))
else ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

PACKAGE     = gromacs
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 5
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.PREFIX  = $(PKGROOT)
RPM.EXTRAS  = AutoReq:No\nAutoProv:No
