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

CUDAGENCODE = --cuda-gencode arch=compute_30,code=sm_30 --cuda-gencode arch=compute_35,code=sm_35 --cuda-gencode arch=compute_37,code=sm_37 --cuda-gencode arch=compute_50,code=sm_50 --cuda-gencode arch=compute_52,code=sm_52 --cuda-gencode arch=compute_60,code=sm_60


NAME           = sdsc-namd
VERSION        = 2.13b1
RELEASE        = 1

SRC_SUBDIR     = namd

SOURCE_NAME    = NAMD
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = 2.13
SOURCE_PKG     = $(SOURCE_NAME)_$(VERSION)_Source.$(SOURCE_SUFFIX)
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

RPM.PREFIX     = $(PKGROOT)
RPM.EXTRAS     = AutoReq:No\nAutoProv:No
