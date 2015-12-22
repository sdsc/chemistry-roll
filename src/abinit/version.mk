ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifneq ("$(ROLLOPTS)", "$(subst abinit_othermpi=,,$(ROLLOPTS))")
  override ROLLMPI = $(subst abinit_othermpi=,,$(filter abinit_othermpi=%,$(ROLLOPTS)))
else ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

PKGROOT        = /opt/abinit
NAME           = sdsc-abinit
VERSION        = 7.10.5
RELEASE        = 0

SRC_SUBDIR     = abinit

SOURCE_NAME    = abinit
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = 7.10.5
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

LIBXC_NAME    = libxc
LIBXC_SUFFIX  = tar.gz
LIBXC_VERSION = 2.0.3
LIBXC_PKG     = $(LIBXC_NAME)-$(LIBXC_VERSION).$(LIBXC_SUFFIX)
LIBXC_DIR     = $(LIBXC_PKG:%.$(LIBXC_SUFFIX)=%)

ATOMPAW_NAME    = atompaw
ATOMPAW_SUFFIX  = tar.gz
ATOMPAW_VERSION = 4.0.0.12
ATOMPAW_PKG     = $(ATOMPAW_NAME)-$(ATOMPAW_VERSION).$(ATOMPAW_SUFFIX)
ATOMPAW_DIR     = $(ATOMPAW_PKG:%.$(ATOMPAW_SUFFIX)=%)

ETSF_IO_NAME    = etsf_io
ETSF_IO_SUFFIX  = tar.gz
ETSF_IO_VERSION = 1.0.4
ETSF_IO_PKG     = $(ETSF_IO_NAME)-$(ETSF_IO_VERSION).$(ETSF_IO_SUFFIX)
ETSF_IO_DIR     = $(ETSF_IO_PKG:%.$(ETSF_IO_SUFFIX)=%)

FOX_NAME    = FoX
FOX_SUFFIX  = tar.gz
FOX_VERSION = 4.1.2
FOX_PKG     = $(FOX_NAME)-$(FOX_VERSION)-full.$(FOX_SUFFIX)
FOX_DIR     = $(FOX_NAME)-$(FOX_VERSION)

TAR_GZ_PKGS    = $(SOURCE_PKG) $(LIBXC_PKG) $(ATOMPAW_PKG) $(ETSF_IO_PKG) $(FOX_PKG)

RPM.EXTRAS     = AutoReq:No
