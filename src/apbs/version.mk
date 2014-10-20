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

NAME           = apbs_$(COMPILERNAME)_$(ROLLMPI)
VERSION        = 1.4
RELEASE        = 1
PKGROOT        = /opt/apbs

SRC_SUBDIR     = apbs

SOURCE_NAME    = APBS
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)-source
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = apbs

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
