NAME               = lammps_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 1Aug14
RELEASE            = 7
RPM.EXTRAS         = AutoReq:No
PKGROOT            = /opt/lammps

SRC_SUBDIR         = lammps

SOURCE_NAME        = lammps
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG)

