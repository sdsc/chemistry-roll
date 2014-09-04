NAME               = gromacs_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 5.0
RELEASE            = 7
RPM.EXTRAS         = AutoReq:No
PKGROOT            = /opt/gromacs

SRC_SUBDIR         = gromacs

SOURCE_NAME        = gromacs
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

GMXTEST_NAME       = gmxtest
GMXTEST_PKG        = $(GMXTEST_NAME).$(SOURCE_SUFFIX)
GMXTEST_DIR        = $(GMXTEST_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG) $(GMXTEST_PKG)

