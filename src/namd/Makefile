# $Id$
#
# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 5.6 (Emerald Boa)
# 		         version 6.1 (Emerald Boa)
# 
# Copyright (c) 2000 - 2013 The Regents of the University of California.
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
# $Log$

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include pull.mk

CC = gcc
FCC = f77
COMPILE_FLAGS = -O2
ifeq ("$(ROLLCOMPILER)", "intel")
  CC = icc        
  FCC = ifort
  COMPILE_FLAGS = -ip -fno-rtti -xHOST
else ifeq ("$(ROLLCOMPILER)", "pgi")
  CC = pgcc
  FCC = pgf90
  COMPILE_FLAGS = -fast
endif

COMPILERSETUP =  \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER) || true; \
  fi; \
  echo === Compiler and version ===; \
  $(CC) --version

CUDASETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load cuda || true; \
  fi; \
  echo === CUDAHOME ===; \
  echo $${CUDAHOME}

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI)
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPIMODULE) || true; \
  fi; \
  if test -z "$${MPIHOME}"; then \
    export MPIHOME=/opt/$(ROLLMPI); \
  fi; \
  echo === MPIHOME ===; \
  echo $${MPIHOME}

CHARMARCH = mpi-linux-x86_64
CHARMBUILDOPTS = -no-build-shared -DCMK_OPTIMIZE
CUDA = 
ifeq ("$(ROLLCOMPILER)", "intel")
  CHARMARCH = mpi-linux-x86_64-$(FCC)-mpicxx
  CHARMBUILDOPTS = mpicxx $(FCC) -j16 -O2  -xHOST
else ifeq ("$(ROLLCOMPILER)", "pgi")
  CHARMARCH = mpi-linux-x86_64-$(FCC)-mpicxx
  CHARMBUILDOPTS = mpicxx $(FCC) -j16 -O2  -fast
endif

ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    CHARMBUILDOPTS += -mavx
    COMPILE_FLAGS += -mavx
  endif
endif

ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  CUDA = --with-cuda
endif

build: $(SRC_DIRS)
	cd $(SOURCE_DIR) && tar xvf charm-*.tar
	patch $(SOURCE_DIR)/arch/Linux-x86_64.fftw patch-files/Linux-x86_64.fftw.patch
	patch $(SOURCE_DIR)/arch/Linux-x86_64.tcl patch-files/Linux-x86_64.tcl.patch
	patch $(SOURCE_DIR)/arch/Linux-x86_64.cuda patch-files/Linux-x86_64.cuda.patch
	cp Linux-x86_64* $(SOURCE_DIR)/arch
	perl -pi -e "s!ROOTDIR!`pwd`/$(SOURCE_DIR)!g" $(SOURCE_DIR)/arch/Linux-x86_64*
	perl -pi -e "s!COMPILE_FLAGS!$(COMPILE_FLAGS)!g" $(SOURCE_DIR)/arch/Linux-x86_64*
	( \
	  $(COMPILERSETUP); \
	  $(CUDASETUP); \
	  $(MPISETUP); \
          mv linux-$(ARCH) $(SOURCE_DIR); \
	  perl -pi -e "s!ROLLCUDA!$${CUDAHOME}!g" $(SOURCE_DIR)/arch/Linux-x86_64.cuda; \
	  cd $(SOURCE_DIR); \
	  cd charm-*[0-9]; \
	  ./build charm++ mpi-linux-x86_64 $(CHARMBUILDOPTS); \
	  cd ..; \
	  ./config Linux-x86_64-MPI-$(CC) --charm-arch $(CHARMARCH) $(CUDA); \
	  cd Linux-x86_64-MPI-$(CC); \
	  $(MAKE) -j 16 \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	cp $(SOURCE_DIR)/*/{charmrun,flipbinpdb,flipdcd,namd2,psfgen} \
	   $(ROOT)/$(PKGROOT)/bin
	cp -r tiny $(ROOT)/$(PKGROOT)
	mkdir -p $(REDHAT.ROOT)/src/build-chemistry-modules
	cat namd.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/namd!g;s!VERSION!$(VERSION)!g;s!ROLLCOMPILER!$(ROLLCOMPILER)!g;s!ROLLMPI!$(ROLLMPI)!g;s!ROLLNETWORK!$(ROLLNETWORK)!g" \
	  > $(REDHAT.ROOT)/src/build-chemistry-modules/$(NAME).module
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SRC_DIRS) _arch

