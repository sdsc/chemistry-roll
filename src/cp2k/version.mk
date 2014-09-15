# Note: normally this package is built with a single compiler and mpi flavor;
# the rpms from multiple builds will overwrite each other.

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = openmpi
endif

ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif

NAME           = cp2k_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION        = 2.4.0
RELEASE        = 9
PKGROOT        = /opt/cp2k

SRC_SUBDIR     = cp2k

SOURCE_NAME    = cp2k
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

LIBINT_NAME    = libint
LIBINT_SUFFIX  = tar.gz
LIBINT_VERSION = 1.1.4
LIBINT_PKG     = $(LIBINT_NAME)-$(LIBINT_VERSION).$(LIBINT_SUFFIX)
LIBINT_DIR     = $(LIBINT_PKG:%.$(LIBINT_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG) $(LIBINT_PKG)

RPM.EXTRAS     = AutoReq:No
