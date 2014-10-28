# Note: normally this package is built with a single compiler and mpi flavor;
# the rpms from multiple builds will overwrite each other.

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = cp2k_$(COMPILERNAME)_$(MPINAME)
VERSION        = 2.5.1
RELEASE        = 2
PKGROOT        = /opt/cp2k

SRC_SUBDIR     = cp2k

SOURCE_NAME    = cp2k
SOURCE_SUFFIX  = tar.bz2
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

LIBINT_NAME    = libint
LIBINT_SUFFIX  = tar.gz
LIBINT_VERSION = 1.1.4
LIBINT_PKG     = $(LIBINT_NAME)-$(LIBINT_VERSION).$(LIBINT_SUFFIX)
LIBINT_DIR     = $(LIBINT_PKG:%.$(LIBINT_SUFFIX)=%)

TAR_BZ2_PKGS   = $(SOURCE_PKG)
TAR_GZ_PKGS    = $(LIBINT_PKG)

RPM.EXTRAS     = AutoReq:No
