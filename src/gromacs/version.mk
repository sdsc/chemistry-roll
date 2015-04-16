ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

/fndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
ifneq ("$(ROLLOPTS)", "$(subst gromacs_othermpi,,$(ROLLOPTS))")
MPINAME := $(firstword $(subst /, ,$(ROLLOTHERMPI)))
else
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))
endif

NAME           = sdsc-gromacs
VERSION        = 5.0.4
RELEASE        = 2
PKGROOT        = /opt/gromacs

SRC_SUBDIR     = gromacs

FFTW_NAME      = fftw
FFTW_SUFFIX    = tar.gz
FFTW_VERSION   = 3.3.4
FFTW_PKG       = $(FFTW_NAME)-$(FFTW_VERSION).$(FFTW_SUFFIX)
FFTW_DIR       = $(FFTW_PKG:%.$(FFTW_SUFFIX)=%)
FFTW_MD5       = 2edab8c06b24feeb3b82bbb3ebf3e7b3

SOURCE_NAME    = gromacs
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

GMXTEST_NAME   = gmxtest
GMXTEST_SUFFIX = tar.gz
GMXTEST_PKG    = $(GMXTEST_NAME).$(GMXTEST_SUFFIX)
GMXTEST_DIR    = $(GMXTEST_PKG:%.$(GMXTEST_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG) $(FFTW_PKG) $(GMXTEST_PKG)

RPM.EXTRAS     = AutoReq:No
