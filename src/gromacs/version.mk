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

NAME           = gromacs_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION        = 5.0
RELEASE        = 9
PKGROOT        = /opt/gromacs

SRC_SUBDIR     = gromacs

SOURCE_NAME    = gromacs
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

GMXTEST_NAME   = gmxtest
GMXTEST_SUFFIX = tar.gz
GMXTEST_PKG    = $(GMXTEST_NAME).$(GMXTEST_SUFFIX)
GMXTEST_DIR    = $(GMXTEST_PKG:%.$(GMXTEST_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG) $(GMXTEST_PKG)

RPM.EXTRAS     = AutoReq:No
