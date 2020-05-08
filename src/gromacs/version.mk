ifneq ("$(ROLLOPTS)", "$(subst gromacs_othercompiler=,,$(ROLLOPTS))")
  override ROLLCOMPILER = $(subst gromacs_othercompiler=,,$(filter gromacs_othercompiler=%,$(ROLLOPTS)))
else ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifneq ("$(ROLLOPTS)", "$(subst gromacs_othermpi=,,$(ROLLOPTS))")
  override ROLLMPI = $(subst gromacs_othermpi=,,$(filter gromacs_othermpi=%,$(ROLLOPTS)))
else ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif

CUDAVERSION=cuda
ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
endif

ifneq ("$(ROLLOPTS)", "$(subst gromacs_othercuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst gromacs_othercuda=,,$(filter gromacs_othercuda=%,$(ROLLOPTS)))
endif

MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-gromacs
VERSION        = 2018.3
RELEASE        = 4
PKGROOT        = /opt/gromacs

SRC_SUBDIR     = gromacs

FFTW_NAME      = fftw
FFTW_SUFFIX    = tar.gz
FFTW_VERSION   = 3.3.8
FFTW_PKG       = $(FFTW_NAME)-$(FFTW_VERSION).$(FFTW_SUFFIX)
FFTW_DIR       = $(FFTW_PKG:%.$(FFTW_SUFFIX)=%)
FFTW_MD5       = 8aac833c943d8e90d51b697b27d4384d

SOURCE_NAME    = gromacs
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

GMXTEST_NAME   = gmxtest
GMXTEST_SUFFIX = tar.gz
GMXTEST_PKG    = $(GMXTEST_NAME).$(GMXTEST_SUFFIX)
GMXTEST_DIR    = $(GMXTEST_PKG:%.$(GMXTEST_SUFFIX)=%)

PLUMED_NAME    = plumed
PLUMED_SUFFIX  = tgz
PLUMED_VERSION = 2.6.0
PLUMED_PKG     = $(PLUMED_NAME)-$(PLUMED_VERSION).$(PLUMED_SUFFIX)
PLUMED_DIR     = $(PLUMED_PKG:%.$(PLUMED_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG) $(FFTW_PKG) $(GMXTEST_PKG)
TGZ_PKGS       = $(PLUMED_PKG)

RPM.PREFIX     = $(PKGROOT)
RPM.EXTRAS     = AutoReq:No\nAutoProv:No
