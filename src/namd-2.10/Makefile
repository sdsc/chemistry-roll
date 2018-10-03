#
# $Id$
#
# @Copyright@
#
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 7.0 (Manzinita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement:
#
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
#
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of
# the associated name, interested parties should contact Technology
# Transfer & Intellectual Property Services, University of California,
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910,
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @Copyright@
#

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

COMPILE_FLAGS = -O2
ifeq ("$(COMPILERNAME)", "intel")
  COMPILE_FLAGS = -ip -fno-rtti -xHOST
else ifeq ("$(COMPILERNAME)", "pgi")
  COMPILE_FLAGS = -fast
endif

CHARMARCH = mpi-linux-x86_64-mpicxx
CHARMBUILDOPTS = -no-build-shared -DCMK_OPTIMIZE --with-production
ifeq ("$(COMPILERNAME)", "intel")
  CHARMBUILDOPTS = mpicxx  -O2  -xHOST
else ifeq ("$(COMPILERNAME)", "pgi")
  CHARMBUILDOPTS = mpicxx  -O2  -fast
else ifeq ("$(COMPILERNAME)", "gnu")
  CHARMBUILDOPTS = mpicxx  -O2
endif

ifneq ("$(ROLLOPTS)", "$(subst avx2,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    COMPILE_FLAGS += -mavx2
  else ifeq ("$(COMPILERNAME)", "intel")
    COMPILE_FLAGS += -xcore-avx2
  endif
else ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    COMPILE_FLAGS += -mavx
  else ifeq ("$(COMPILERNAME)", "intel")
    COMPILE_FLAGS += -xavx
  endif
endif

CUDABUILD = no
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  CUDAOPT = --with-cuda --cuda-prefix $${CUDAHOME}
  CUDABUILD = yes
endif

MODULE_LOAD_NAMD_CUDA = $(call MODULE_LOAD_PACKAGE, $(CUDAVERSION), CUDAHOME)
DESCRIBE_NAMD_CUDA = echo built with cuda $(call GET_MODULE_VERSION, $(CUDAVERSION))

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI); \
	  $(DESCRIBE_NAMD_CUDA) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo University of Illinois > $@

build: $(SRC_DIRS)
	cd $(SOURCE_DIR) && tar xvf charm-*.tar
	cp Linux-x86_64* $(SOURCE_DIR)/arch
	perl -pi -e "s!COMPILE_FLAGS!$(COMPILE_FLAGS)!g" $(SOURCE_DIR)/arch/Linux-x86_64*
	patch $(SOURCE_DIR)/arch/Linux-x86_64.cuda patch-files/Linux-x86_64.cuda.patch
	if test "$(COMPILERNAME)" != "intel"; then \
	  perl -pi -e "s! -auto ! !" $(SOURCE_DIR)/charm*/src/arch/mpi-linux-x86_64/cc-mpicxx.sh; \
	fi
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_NAMD_CUDA); \
	  cd $(SOURCE_DIR); \
	  cd charm-*[0-9]; \
	  ./build charm++ mpi-linux-x86_64 $(CHARMBUILDOPTS); \
	  cd ..; \
	  ./config Linux-x86_64-MPI-$(CC) \
	           --charm-arch $(CHARMARCH) \
	           --fftw-prefix $(CURDIR)/$(FFTW_DIR) \
	           --tcl-prefix $(CURDIR)/$(TCL_DIR) --without-cuda; \
	 cd Linux-x86_64-MPI-$(CC); \
	 $(MAKE) -j 16; \
         mkdir $(PWD)/bin; \
         cp {charmrun,flipbinpdb,flipdcd,namd2,psfgen} $(PWD)/bin; \
	 if test "$(CUDABUILD)" = "yes"; then \
           cd .. ; \
           make  clean; \
	   rm -rf Linux-x86_64-MPI-$(CC); \
	   ./config Linux-x86_64-MPI-$(CC) \
	           --charm-arch $(CHARMARCH) \
	           --fftw-prefix $(CURDIR)/$(FFTW_DIR) \
	           --tcl-prefix $(CURDIR)/$(TCL_DIR) \
	           $(CUDAOPT); \
	   cd Linux-x86_64-MPI-$(CC); \
	   $(MAKE) -j 16; \
           cp namd2 $(PWD)/bin/namd2.cuda; \
          fi \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	cp -r tiny $(ROOT)/$(PKGROOT)
	cp $(PWD)/bin/* $(ROOT)/$(PKGROOT)/bin
	rm -rf $(PWD)/bin
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SRC_DIRS) $(FFTW_DIR) _arch DESCRIPTION LICENSE
