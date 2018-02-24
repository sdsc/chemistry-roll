ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

CUDAVERSION=cuda
ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
endif
ifneq ("$(ROLLOPTS)", "$(subst namd_othercuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst namd_othercuda=,,$(filter namd_othercuda=%,$(ROLLOPTS)))
endif

VERSION        = 2.9
NAME           = sdsc-namd-$(VERSION)
RELEASE        = 16
PKGROOT        = /opt/namd/$(VERSION)

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
FFTW_DIR       = linux-$(ARCH)

TGZ_PKGS       = $(SOURCE_PKG)
TAR_GZ_PKGS    = $(TINY_PKG) $(TCL_PKG) $(FFTW_PKG)

RPM.EXTRAS     = AutoReq:No
