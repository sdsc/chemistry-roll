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

PKGROOT = /opt/cp2k
SOURCE = cp2k-$(VERSION)
REDHAT.ROOT = $(PWD)/../../

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load intel; \
    export MKL_HOME=$${MKL_ROOT}; \
    module unload intel; \
    latestModule=`module avail 2>&1 | grep -o '$(ROLLCOMPILER)/[^ (]*' | sed 's/$(ROLLCOMPILER).//' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1`; \
    module load $(ROLLCOMPILER)/$${latestModule}; \
  fi

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI)
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

OMPI_CFLAGS=
OMPI_CXXFLAGS=
OMPI_FFLAGS=
OMPI_FCFLAGS=
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

ROLLTYPEMKL = _openmpi_
ifeq ("$(ROLLMPI)", "mvapich")
  ROLLTYPEMKL = _
else ifeq ("$(ROLLMPI)", "mpich2")
  ROLLTYPEMKL = _intelmpi_
else ifeq ("$(ROLLMPI)", "mvapich2")
  ROLLTYPEMKL = _intelmpi_
endif

CXX = g++
CC = gcc
FC = gcc
ROLLMAKEFILE = Linux-x86-64-$(ROLLCOMPILER)
COMPILE_FLAGS = -O2
ifeq ("$(ROLLCOMPILER)", "intel")
  CXX = icpc
  CC = icc
  FC = ifort
  COMPILE_FLAGS = -O2
  OMPI_CFLAGS=-pthread
  OMPI_CXXFLAGS=-pthread
  OMPI_FFLAGS=-pthread
  OMPI_FCFLAGS=-pthread
else ifeq ("$(ROLLCOMPILER)", "pgi")
  CXX = pgCC
  CC = pgcc
  FC = pgf90
  COMPILE_FLAGS = -fast
else ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  COMPILE_FLAGS += -mavx
endif
COMPILE_FLAGS += -I$(REDHAT.ROOT)/src/cp2k/$(SOURCE)/obj/$(ROLLMAKEFILE)/popt
LIBINT=1.1.4

build:
	tar zxvf $(SOURCE).tar.gz
	cp patch-files/$(ROLLMAKEFILE).popt $(SOURCE)/arch
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  fftwHome=`find /opt/fftw/3* -maxdepth 0`/$(ROLLCOMPILER)/$(ROLLMPI)/$(ROLLNETWORK); \
	  perl -pi -e "s!MKL_ROOT!$${MKL_HOME}!" $(SOURCE)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!ROLLTYPEMKL!$(ROLLTYPEMKL)!g" $(SOURCE)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!ROLLFFTW!$$fftwHome!" $(SOURCE)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!ROLLLIBINT!$(PWD)/$(SOURCE)/libint/lib!" $(SOURCE)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!ROLLWRAPPER!$(PWD)/$(SOURCE)/tools/hfx_tools/libint_tools!" $(SOURCE)/arch/$(ROLLMAKEFILE).popt; \
	  export CC=$(CC); \
	  export CFLAGS="$(COMPILE_FLAGS)"; \
	  export FC=$(FC); \
	  export FCFLAGS="$(COMPILE_FLAGS)"; \
	  export CXX=$(CXX); \
	  export CXXFLAGS="$(COMPILE_FLAGS)"; \
	  export FFLAGS="$(COMPILE_FLAGS)"; \
          export OMPI_CFLAGS="$(OMPI_CFLAGS)"; \
          export OMPI_CXXFLAGS="$(OMPI_CXXFLAGS)"; \
          export OMPI_FFLAGS="$(OMPI_FFLAGS)"; \
          export OMPI_FCFLAGS="$(OMPI_FCFLAGS)"; \
	  cd $(SOURCE); \
	  tar xvzf ../libint-$(LIBINT).tar.gz; \
	  mkdir libint; \
	  cd libint-$(LIBINT); \
	  ./configure --with-cc-optflags="$(COMPILE_FLAGS)" \
	    --with-cxx-optflags="$(COMPILE_FLAGS)" --with-libint-max-am=5 \
	    --with-libderiv-max-am1=4 --prefix=`pwd`/../libint; \
	  make -j 16; \
	  make install; \
	  cd ../tools/hfx_tools/libint_tools; \
	  $(CXX) $(COMPILE_FLAGS) -c libint_cpp_wrapper.cpp -I../../../libint/include; \
	  cd ../../../makefiles; \
	  make -j 16 CC=mpicc CXX=mpicxx FC=mpif90 ARCH=$(ROLLMAKEFILE) VERSION=popt \
	)

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/test
	cp $(SOURCE)/exe/$(ROLLMAKEFILE)/cp2k.popt $(ROOT)/$(PKGROOT)/bin
	cp -r $(SOURCE)/tests/EP/* $(ROOT)/$(PKGROOT)/test/
	rm -fr $(ROOT)/$(PKGROOT)/test/CVS

clean::
	rm -rf $(SOURCE)
