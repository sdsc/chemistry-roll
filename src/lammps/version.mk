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

NAME           = lammps_$(COMPILERNAME)_$(ROLLMPI)
VERSION        = $(shell date -d "$(SOURCE_VERSION)" +%Y%m%d)
RELEASE        = 1
PKGROOT        = /opt/lammps

SRC_SUBDIR     = lammps

SOURCE_NAME    = lammps
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION := 1Aug14
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
