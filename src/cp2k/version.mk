NAME               = cp2k_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 2.4.0
RELEASE            = 4
RPM.EXTRAS         = AutoReq:No
PKGROOT            = /opt/cp2k

SRC_SUBDIR         = cp2k

SOURCE_NAME        = cp2k
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

LIBINT_NAME        = libint
LIBINT_VERSION     = 1.1.4
LIBINT_PKG         = $(LIBINT_NAME)-$(LIBINT_VERSION).$(SOURCE_SUFFIX)
LIBINT_DIR         = $(LIBINT_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG)

