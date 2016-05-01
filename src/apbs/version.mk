ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-apbs
VERSION        = 1.4.2
RELEASE        = 1
PKGROOT        = /opt/apbs

SRC_SUBDIR     = apbs

SOURCE_NAME    = apbs
SOURCE_SUFFIX  = tgz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

MALOC_SOURCE_NAME    = maloc
MALOC_SOURCE_SUFFIX  = tar.gz
MALOC_SOURCE_VERSION = 1.5
MALOC_SOURCE_PKG     = $(MALOC_SOURCE_NAME)-$(MALOC_SOURCE_VERSION).$(MALOC_SOURCE_SUFFIX)
MALOC_SOURCE_DIR     = maloc

PUNC_SOURCE_NAME    = punc
PUNC_SOURCE_SUFFIX  = tar.gz
PUNC_SOURCE_VERSION = 1.5
PUNC_SOURCE_PKG     = $(PUNC_SOURCE_NAME)-$(PUNC_SOURCE_VERSION).$(PUNC_SOURCE_SUFFIX)
PUNC_SOURCE_DIR     = punc

GAMER_SOURCE_NAME    = gamer
GAMER_SOURCE_SUFFIX  = tar.gz
GAMER_SOURCE_VERSION = 1.5
GAMER_SOURCE_PKG     = $(GAMER_SOURCE_NAME)-$(GAMER_SOURCE_VERSION).$(GAMER_SOURCE_SUFFIX)
GAMER_SOURCE_DIR     = gamer

MC_SOURCE_NAME    = mc
MC_SOURCE_SUFFIX  = tar.gz
MC_SOURCE_VERSION = 1.5
MC_SOURCE_PKG     = $(MC_SOURCE_NAME)-$(MC_SOURCE_VERSION).$(MC_SOURCE_SUFFIX)
MC_SOURCE_DIR     = mc

TGZ_PKGS       = $(SOURCE_PKG)
TAR_GZ_PKGS    = $(MALOC_SOURCE_PKG) $(PUNC_SOURCE_PKG) $(GAMER_SOURCE_PKG) $(MC_SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
