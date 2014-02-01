NAME               = namd_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 2.9
RELEASE            = 0
RPM.EXTRAS         = AutoReq:No
PKGROOT            = /opt/namd

SRC_SUBDIR         = namd

SOURCE_NAME        = namd
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tgz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TINY_NAME          = tiny
TINY_SUFFIX        = tar.gz
TINY_PKG           = $(TINY_NAME).$(TINY_SUFFIX)
TINY_DIR           = $(TINY_PKG:%.$(TINY_SUFFIX)=%)

TCL_NAME           = tcl-linux
TCL_VERSION        = $(ARCH)
TAR_GZ_SUFFIX      = tar.gz
TCL_PKG            = $(TCL_NAME)-$(ARCH).$(TAR_GZ_SUFFIX)
TCL_DIR            = $(TCL_PKG:%.$(TAR_GZ_SUFFIX)=%)

FFTW_NAME          = fftw-linux
FFTW_VERSION       = $(ARCH)
FFTW_PKG           = $(FFTW_NAME)-$(ARCH).$(TAR_GZ_SUFFIX)
FFTW_DIR           = $(FFTW_PKG:%.$(TAR_GZ_SUFFIX)=%)

TGZ_PKGS           = $(SOURCE_PKG)
TAR_GZ_PKGS        = $(TINY_PKG) $(TCL_PKG) $(FFTW_PKG)

