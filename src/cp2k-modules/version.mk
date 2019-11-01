ifneq ("$(ROLLOPTS)", "$(subst cp2k_othercompiler=,,$(ROLLOPTS))")
  override ROLLCOMPILER = $(subst cp2k_othercompiler=,,$(filter cp2k_othercompiler=%,$(ROLLOPTS)))
else ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifneq ("$(ROLLOPTS)", "$(subst cp2k_othermpi=,,$(ROLLOPTS))")
  override ROLLMPI = $(subst cp2k_othermpi=,,$(filter cp2k_othermpi=%,$(ROLLOPTS)))
else ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))



PACKAGE     = cp2k
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 18
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.PREFIX  = $(PKGROOT)
RPM.EXTRAS  = AutoReq:No\nAutoProv:No

