ifneq ("$(ROLLOPTS)", "$(subst abinit_othermpi=,,$(ROLLOPTS))")
  override ROLLMPI = $(subst abinit_othermpi=,,$(filter abinit_othermpi=%,$(ROLLOPTS)))
else ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif

PACKAGE     = abinit
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 0
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
