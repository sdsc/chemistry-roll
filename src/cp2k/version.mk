ifneq ("$(ROLLOPTS)", "$(subst cp2k_othercompiler=,,$(ROLLOPTS))")
  override ROLLCOMPILER = $(subst cp2k_othercompiler=,,$(filter cp2k_othercompiler=%,$(ROLLOPTS)))
else ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif

COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

CUDAVERSION=cuda
ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
endif
ifneq ("$(ROLLOPTS)", "$(subst cp2k_othercuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst cp2k_othercuda=,,$(filter cp2k_othercuda=%,$(ROLLOPTS)))
endif

ifneq ("$(ROLLOPTS)", "$(subst cp2k_othermpi=,,$(ROLLOPTS))")
  override ROLLMPI = $(subst cp2k_othermpi=,,$(filter cp2k_othermpi=%,$(ROLLOPTS)))
else ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))


CUDA_CAPABILITIES=37
ifneq ("$(ROLLOPTS)", "$(subst cudacapabilities=,,$(ROLLOPTS))")
  CUDA_CAPABILITIES = $(subst cudacapabilities=,,$(filter cudacapabilities=%,$(ROLLOPTS)))
endif


NAME           = sdsc-cp2k
VERSION        = 7.1
RELEASE        = 1
PKGROOT        = /opt/cp2k

SRC_SUBDIR     = cp2k

SOURCE_NAME    = cp2k
SOURCE_SUFFIX  = tar.bz2
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)


LIBINT_NAME    = libint
LIBINT_SUFFIX  = tgz
LIBINT_VERSION = 2.6.0
LIBINT_PKG     = $(LIBINT_NAME)-v$(LIBINT_VERSION)-cp2k-lmax-7.$(LIBINT_SUFFIX)
LIBINT_DIR     = $(LIBINT_PKG:%.$(LIBINT_SUFFIX)=%)

LIBXC_NAME     = libxc
LIBXC_SUFFIX   = tar.gz
LIBXC_VERSION  = 4.2.3
LIBXC_PKG      = $(LIBXC_NAME)-$(LIBXC_VERSION).$(LIBXC_SUFFIX)
LIBXC_DIR      = $(LIBXC_PKG:%.$(LIBXC_SUFFIX)=%)
 
LIBXSMM_NAME     = libxsmm
LIBXSMM_SUFFIX   = tar.gz
LIBXSMM_VERSION  = 1.15
LIBXSMM_PKG      = $(LIBXSMM_NAME)-$(LIBXSMM_VERSION).$(LIBXSMM_SUFFIX)
LIBXSMM_DIR      = $(LIBXSMM_PKG:%.$(LIBXSMM_SUFFIX)=%)

TAR_BZ2_PKGS   = $(SOURCE_PKG)
TAR_GZ_PKGS    = $(LIBXC_PKG) $(LIBXSMM_PKG)
TGZ_PKGS       = $(LIBINT_PKG)

RPM.PREFIX     = $(PKGROOT)
RPM.EXTRAS     = AutoReq:No\nAutoProv:No
