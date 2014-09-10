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

NAME           = namd_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION        = 2.9
RELEASE        = 8
PKGROOT        = /opt/namd

SRC_SUBDIR     = namd

SOURCE_NAME    = namd
SOURCE_SUFFIX  = tgz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TINY_NAME      = tiny
TINY_SUFFIX    = tar.gz
TINY_PKG       = $(TINY_NAME).$(TINY_SUFFIX)
TINY_DIR       = $(TINY_PKG:%.$(TINY_SUFFIX)=%)

TCL_NAME       = tcl-linux
TCL_SUFFIX     = tar.gz
TCL_VERSION    = $(ARCH)
TCL_PKG        = $(TCL_NAME)-$(ARCH).$(TCL_SUFFIX)
TCL_DIR        = $(TCL_PKG:%.$(TCL_SUFFIX)=%)

FFTW_NAME      = fftw-linux
FFTW_SUFFIX    = tar.gz
FFTW_VERSION   = $(ARCH)
FFTW_PKG       = $(FFTW_NAME)-$(ARCH).$(FFTW_SUFFIX)
FFTW_DIR       = $(FFTW_PKG:%.$(FFTW_SUFFIX)=%)

TGZ_PKGS       = $(SOURCE_PKG)
TAR_GZ_PKGS    = $(TINY_PKG) $(TCL_PKG) $(FFTW_PKG)

RPM.EXTRAS     = AutoReq:No
