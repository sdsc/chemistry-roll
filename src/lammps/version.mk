ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

CUDAVERSION=cuda
ifneq ("$(ROLLOPTS)", "$(subst lammps_othercuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst lammps_othercuda=,,$(filter lammps_othercuda=%,$(ROLLOPTS)))
endif

NAME           = sdsc-lammps
VERSION        = $(shell date -d "$(SOURCE_VERSION)" +%Y%m%d)
RELEASE        = 0
PKGROOT        = /opt/lammps

SRC_SUBDIR     = lammps

SOURCE_NAME    = lammps
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION := 31Mar17
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
