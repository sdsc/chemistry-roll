#
# $Id$
#
# @Copyright@
#
# 				Rocks(tm)
# 		         www.rocksclusters.org
# 		        version 4.3 (Mars Hill)
#
# Copyright (c) 2000 - 2011 The Regents of the University of California.
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
# 	"This product includes software developed by the Rocks(tm)
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

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif
ifndef ROLLMPI
  ROLLMPI = openmpi
endif

PKGROOT = /opt/namd
SOURCE = namd-$(VERSION)
REDHAT.ROOT = $(PWD)/../../

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    latestModule=`module avail 2>&1 | grep -o '$(ROLLCOMPILER)/[^ (]*' | sed 's/$(ROLLCOMPILER).//' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1`; \
    module load $(ROLLCOMPILER)/$${latestModule}; \
  fi

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI)
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPIMODULE); \
  fi; \
  export MPI_HOME=`which mpicxx | perl -pe 's!/bin/.*!!'`; \
  if test -z "$${MPI_HOME}"; then \
    export MPI_HOME=/opt/$(ROLLMPI); \
  fi; \
  echo Using MPI from $${MPI_HOME}; \
  export PATH=$${PATH}:$${MPI_HOME}/bin; \
  export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${MPI_HOME}/lib

CXX = g++
CC = gcc
FCC = f77
COMPILER_FLAGS = -O2
CHARMARCH = mpi-linux-x86_64
CHARMBUILDOPTS = -no-build-shared -DCMK_OPTIMIZE
ifeq ("$(ROLLCOMPILER)", "intel")
  CXX = icpc        
  CC = icc
  FCC = ifort
  CHARMARCH = mpi-linux-x86_64-$(FCC)-mpicxx
  CHARMBUILDOPTS = mpicxx $(FCC) -j16 -O2  -xHOST
  COMPILER_FLAGS = -ip -fno-rtti -xHOST
else ifeq ("$(ROLLCOMPILER)", "pgi")
  CXX = pgCC
  CC = pgcc
  FCC = pgf90
  CHARMARCH = mpi-linux-x86_64-$(FCC)-mpicxx
  CHARMBUILDOPTS = mpicxx $(FCC) -j16 -O2  -fast
  COMPILER_FLAGS = -fast
else ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  CHARMBUILDOPTS += -mavx
  COMPILER_FLAGS += -mavx
endif

build:
	tar zxvf $(SOURCE).tgz
	tar zxvf tiny.tar.gz
	cd $(SOURCE) && tar xvf charm-*.tar
	cp patch-files/Linux-x86_64* $(SOURCE)/arch
	perl -pi -e "s!ROOTDIR!`pwd`/$(SOURCE)!g" $(SOURCE)/arch/Linux-x86_64*
	perl -pi -e "s!COMPILER_FLAGS!$(COMPILER_FLAGS)!g" \
	  $(SOURCE)/arch/Linux-x86_64*
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE); \
	  tar zxvf $(REDHAT.ROOT)/src/fftw-linux-x86_64.tar.gz; \
	  tar zxvf $(REDHAT.ROOT)/src/tcl-linux-x86_64.tar.gz; \
	  cd charm-*[0-9]; \
	  ./build charm++ mpi-linux-x86_64 $(CHARMBUILDOPTS); \
	  cd ..; \
	  ./config Linux-x86_64-MPI-$(CC) --charm-arch $(CHARMARCH); \
	  cd Linux-x86_64-MPI-$(CC); \
	  make -j 16 \
	)

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	mkdir -p $(REDHAT.ROOT)/src/build-chemistry-modules
	cp $(SOURCE)/*/{charmrun,flipbinpdb,flipdcd,namd2,psfgen} \
	   $(ROOT)/$(PKGROOT)/bin
	cp -r tiny $(ROOT)/$(PKGROOT)
        cat namd.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/.$(ROLLCOMPILER)/namd!g;s!VERSION!$(VERSION)!g;s!ROLLCOMPILER!$(ROLLCOMPILER)!g" \
          > $(REDHAT.ROOT)/src/build-chemistry-modules/$(NAME).module

clean::
	rm -rf $(SOURCE) tiny
