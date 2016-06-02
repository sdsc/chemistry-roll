ROLLCUDA =
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  ROLLCUDA = cuda
endif

PACKAGE     = namd
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 5
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

EXTRA_MODULE_VERSIONS = 2.9

RPM.EXTRAS  = AutoReq:No
