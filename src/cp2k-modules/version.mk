ifneq ("$(ROLLOPTS)", "$(subst gromacs_othercompiler=,,$(ROLLOPTS))")
  override ROLLCOMPILER = $(subst gromacs_othercompiler=,,$(filter gromacs_othercompiler=%,$(ROLLOPTS)))
else ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))


PACKAGE     = cp2k
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 17
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.PREFIX  = $(PKGROOT)
RPM.EXTRAS  = AutoReq:No\nAutoProv:No
