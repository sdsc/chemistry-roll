ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif

ifneq ("$(ROLLOPTS)", "$(subst gromacs_othermpi=,,$(ROLLOPTS))")
  override ROLLMPI = $(subst gromacs_othermpi=,,$(filter gromacs_othermpi=%,$(ROLLOPTS)))
else ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif

PACKAGE     = gromacs
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 5
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
