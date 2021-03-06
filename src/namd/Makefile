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
  COMPILE_FLAGS = -ip -xHOST
else ifeq ("$(COMPILERNAME)", "pgi")
  COMPILE_FLAGS = -fast
endif

MODULE_LOAD_NAMD_CUDA = $(call MODULE_LOAD_PACKAGE, $(CUDAVERSION), CUDAHOME)
DESCRIBE_NAMD_CUDA = echo built with cuda $(call GET_MODULE_VERSION, $(CUDAVERSION))

CHARMFLAGS=--with-production
CHARMARCH = mpi-linux-x86_64
CHARMFILEXTENSION = mpicxx
CHARMBUILDOPTS = mpicxx

IBVERBS = no
ifneq ("$(MPINAME)","$(subst _ib,,$(MPINAME))")
   IBVERBS = yes
else ifeq ("$(MPINAME)","intelmpi")
   IBVERBS = yes
endif

LIBIBVERBS=
ifeq ($(IBVERBS),yes)
  CHARMCUDAARCH = verbs-linux-x86_64
  ifeq ("$(COMPILERNAME)", "intel")
    CHARMCUDABUILDOPTS = smp icc
  else ifeq ("$(COMPILERNAME)", "pgi")
    CHARMCUDABUILDOPTS = smp pgcc
  else ifeq ("$(COMPILERNAME)", "gnu")
    LIBIBVERBS = -libverbs
    CHARMCUDABUILDOPTS = smp gcc
  endif
else
  CHARMCUDAARCH = multicore-linux-x86_64
  ifeq ("$(COMPILERNAME)", "intel")
    CHARMCUDABUILDOPTS = icc
  else ifeq ("$(COMPILERNAME)", "pgi")
    CHARMCUDABUILDOPTS = pgcc
  else ifeq ("$(COMPILERNAME)", "gnu")
    CHARMCUDABUILDOPTS = gcc
  endif
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

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI); \
          if test "$(CUDABUILD)" = "yes"; then \
	     $(DESCRIBE_NAMD_CUDA); \
          fi \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo University of Illinois > $@

build: $(SRC_DIRS)
	cd $(SOURCE_DIR) && tar xvf charm-*.tar
	cp Linux-x86_64* $(SOURCE_DIR)/arch
	perl -pi -e "s!COMPILE_FLAGS!$(COMPILE_FLAGS)!g" $(SOURCE_DIR)/arch/Linux-x86_64*
	patch $(SOURCE_DIR)/Make.charm patch-files/Make.charm.patch
	perl -pi -e "s!LIBIBVERBS!$(LIBIBVERBS)!g" $(SOURCE_DIR)/arch/Linux-x86_64*
	if test "$(COMPILERNAME)" != "intel"; then \
	  perl -pi -e "s! -auto ! !" $(SOURCE_DIR)/charm*/src/arch/mpi-linux-x86_64/cc-mpicxx.sh; \
	fi
	( \
          CHARMFILEEXTENSION=`echo $(CHARMBUILDOPTS)| sed 's/ /-/g'`; \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MPI); \
          CHARMDIR=`find $(CURDIR)/$(SOURCE_DIR) -maxdepth 1 \( -name charm\*  -a -type d \)`; \
          perl -pi -e "s!CHARMDIR!$${CHARMDIR}!g" $(SOURCE_DIR)/Make.charm; \
	  cd $(SOURCE_DIR); \
	  cd charm-*[0-9]; \
          ./build charm++ $(CHARMARCH) $(CHARMBUILDOPTS) $(CHARMFLAGS); \
	  cd ..; \
	  ./config Linux-x86_64-$(CC) \
	           --charm-arch $(CHARMARCH)-$${CHARMFILEEXTENSION} \
	           --fftw-prefix $(CURDIR)/$(FFTW_DIR) \
	           --tcl-prefix $(CURDIR)/$(TCL_DIR) --without-cuda; \
	 cd Linux-x86_64-$(CC); \
	 $(MAKE) -j 16; \
         mkdir $(PWD)/bin; \
         cp {flipbinpdb,flipdcd,namd2,psfgen} $(PWD)/bin; \
	 if test "$(CUDABUILD)" = "yes"; then \
	   $(MODULE_LOAD_NAMD_CUDA); \
           CHARMCUDAFILEEXTENSION=`echo $(CHARMCUDABUILDOPTS)| sed 's/ /-/g'`; \
           cd ..; \
           rm -rf Linux-x86_64-$(CC) charm-*[0-9]; \
	   perl -pi -e "s!CUDAHOME!$${CUDAHOME}!g" arch/Linux-x86_64*; \
           tar xvf charm-*.tar; \
           cd charm-*[0-9]; \
           ./build charm++ $(CHARMCUDAARCH) $(CHARMCUDABUILDOPTS) $(CHARMFLAGS); \
	   cd ..; \
           ./config Linux-x86_64-cuda-$(CC) \
                   --charm-arch $(CHARMCUDAARCH)-$${CHARMCUDAFILEEXTENSION} \
                   --fftw-prefix $(CURDIR)/$(FFTW_DIR) \
                   --tcl-prefix $(CURDIR)/$(TCL_DIR) \
                   $(CUDAOPT); \
	   cd Linux-x86_64-cuda-$(CC); \
	   $(MAKE) -j 16; \
           cp namd2 $(PWD)/bin/namd2.cuda; \
           cp charmrun $(PWD)/bin; \
          fi \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	cp -r tiny $(ROOT)/$(PKGROOT)
	cp $(PWD)/bin/* $(ROOT)/$(PKGROOT)/bin
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SRC_DIRS) $(FFTW_DIR) _arch DESCRIPTION LICENSE bin
