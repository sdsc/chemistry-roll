ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-gromacs
VERSION        = 5.0.4
RELEASE        = 0
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
