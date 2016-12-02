CUDAVERSION=cuda
ifneq ("$(ROLLOPTS)", "$(subst cp2k_othercuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst cp2k_othercuda=,,$(filter cp2k_othercuda=%,$(ROLLOPTS)))
endif


ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-cp2k
VERSION        = 3.0
RELEASE        = 2
PKGROOT        = /share/apps/compute/cp2k

SRC_SUBDIR     = cp2k

SOURCE_NAME    = cp2k
SOURCE_SUFFIX  = tar.bz2
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

LIBINT_NAME    = libint
LIBINT_SUFFIX  = tar.gz
LIBINT_VERSION = 1-1-6
LIBINT_PKG     = $(LIBINT_NAME)-release-$(LIBINT_VERSION).$(LIBINT_SUFFIX)
LIBINT_DIR     = $(LIBINT_PKG:%.$(LIBINT_SUFFIX)=%)

LIBXC_NAME    = libxc
LIBXC_SUFFIX  = tar.gz
LIBXC_VERSION = 2.2.2
LIBXC_PKG     = $(LIBXC_NAME)-$(LIBXC_VERSION).$(LIBXC_SUFFIX)
LIBXC_DIR     = $(LIBXC_PKG:%.$(LIBXC_SUFFIX)=%)

PLUMED_NAME    = plumed
PLUMED_SUFFIX  = tgz
PLUMED_VERSION = 2.2.3
PLUMED_PKG     = $(PLUMED_NAME)-$(PLUMED_VERSION).$(PLUMED_SUFFIX)
PLUMED_DIR     = $(PLUMED_PKG:%.$(PLUMED_SUFFIX)=%)

TAR_BZ2_PKGS   = $(SOURCE_PKG)
TAR_GZ_PKGS    = $(LIBINT_PKG) $(LIBXC_PKG)
TGZ_PKGS       = $(PLUMED_PKG)

RPM.EXTRAS     = AutoReq:No
