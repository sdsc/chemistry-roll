ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-namd-$(VERSION)
VERSION        = 2.11
RELEASE        = 1

SRC_SUBDIR     = namd

SOURCE_NAME    = NAMD
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = 2.11
SOURCE_PKG     = $(SOURCE_NAME)_$(SOURCE_VERSION)_Source.$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

PKGROOT        = /opt/namd/$(SOURCE_VERSION)

TINY_NAME      = tiny
TINY_SUFFIX    = tar.gz
TINY_PKG       = $(TINY_NAME).$(TINY_SUFFIX)
TINY_DIR       = $(TINY_PKG:%.$(TINY_SUFFIX)=%)

TCL_NAME       = tcl
TCL_SUFFIX     = tar.gz
TCL_VERSION    = 8.5.9
TCL_PKG        = $(TCL_NAME)$(TCL_VERSION)-linux-$(ARCH).$(TCL_SUFFIX)
TCL_DIR        = $(TCL_PKG:%.$(TCL_SUFFIX)=%)

FFTW_NAME      = fftw-linux
FFTW_SUFFIX    = tar.gz
FFTW_VERSION   = $(ARCH)
FFTW_PKG       = $(FFTW_NAME)-$(ARCH).$(FFTW_SUFFIX)
FFTW_DIR       = linux-$(ARCH)

TAR_GZ_PKGS    = $(SOURCE_PKG) $(TINY_PKG) $(TCL_PKG) $(FFTW_PKG)

RPM.EXTRAS     = AutoReq:No