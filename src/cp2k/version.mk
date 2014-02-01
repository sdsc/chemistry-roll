NAME               = cp2k_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 2.4.0
RELEASE            = 0
RPM.EXTRAS         = AutoReq:No
PKGROOT            = /opt/cp2k

SRC_SUBDIR         = cp2k

CP2K_NAME        = cp2k
CP2K_VERSION     = $(VERSION)
CP2K_SUFFIX      = tar.gz
CP2K_PKG         = $(CP2K_NAME)-$(CP2K_VERSION).$(CP2K_SUFFIX)
CP2K_DIR         = $(CP2K_PKG:%.$(CP2K_SUFFIX)=%)

LIBINT_SUFFIX      = tar.gz
LIBINT_NAME        = libint
LIBINT_VERSION     = 1.1.4
LIBINT_PKG         = $(LIBINT_NAME)-$(LIBINT_VERSION).$(LIBINT_SUFFIX)
LIBINT_DIR         = $(LIBINT_PKG:%.$(LIBINT_SUFFIX)=%)

TAR_GZ_PKGS        = $(CP2K_PKG) $(LIBINT_PKG)

