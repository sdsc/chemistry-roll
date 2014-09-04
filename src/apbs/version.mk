NAME               = apbs_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 1.3
RELEASE            = 7
RPM.EXTRAS         = AutoReq:No
PKGROOT            = /opt/apbs

SRC_SUBDIR         = apbs

SOURCE_NAME        = apbs
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tgz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS           = $(SOURCE_PKG)

