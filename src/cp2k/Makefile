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

ifeq ("$(ROLLNETWORK)", "eth")
  MPI= $(ROLLMPI)
else
  MPI= $(ROLLMPI)_$(ROLLNETWORK)
endif


ROLLTYPEMKL=_openmpi_
ifeq ("$(ROLLMPI)","mpich")
    ROLLTYPEMKL=_
endif
ifeq ("$(ROLLMPI)","mvapich")
    ROLLTYPEMKL=_
endif
ifeq ("$(ROLLMPI)","mpich2")
    ROLLTYPEMKL=_intelmpi_
endif
ifeq ("$(ROLLMPI)","mvapich2")
    ROLLTYPEMKL=_intelmpi_
endif


PKGROOT = /opt/cp2k
SOURCE = cp2k.$(VERSION)
REDHAT.ROOT = $(PWD)/../../

-include $(ROCKSROOT)/etc/Rules.mk

ROLLMAKEFILE = Linux-x86-64-gfortran
COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER); \
  fi

CXX=g++
ifeq ("$(ROLLCOMPILER)", "intel")
  ROLLMAKEFILE = Linux-x86-64-intel
  CXX = icpc
else ifeq ("$(ROLLCOMPILER)", "pgi")
  ROLLMAKEFILE = Linux-x86-64-pgi
  CXX = pgCC
endif

ifeq ("$(ROLLNETWORK)", "eth")
  OPENMPISUFFIX =
else
  OPENMPISUFFIX = _$(ROLLNETWORK)
endif

ifeq ("${MKL_ROOT}", "")
   export MKL_ROOT=/opt/intel/Compiler/11.1/072/mkl
endif

MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPI); \
  fi; \
  export MPI_HOME=`which mpicxx | perl -pe 's!/bin/.*!!'`; \
  if test -z "$${MPI_HOME}"; then \
    export MPI_HOME=/opt/$(MPI); \
  fi; \
  echo Using MPI from $${MPI_HOME}; \
  export PATH=$${PATH}:$${MPI_HOME}/bin; \
  export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${MPI_HOME}/lib

F90COMP = gfortran
NCPUS=128
ROLLFFTW = /opt/fftw/3.2.1/$(ROLLCOMPILER)


build:
	tar zxvf $(SOURCE).tar.gz
	cp patch-files/$(ROLLMAKEFILE).popt $(SOURCE)/arch
	perl -pi -e "s!ROLL_MATHPATH!$${MKL_ROOT}/lib/em64t!" $(SOURCE)/arch/$(ROLLMAKEFILE).popt; \
        perl -pi -e "s!ROLLTYPEMKL!$(ROLLTYPEMKL)!g" $(SOURCE)/arch/$(ROLLMAKEFILE).popt; \
	perl -pi -e "s!ROLLFFTW!$(ROLLFFTW)!" $(SOURCE)/arch/$(ROLLMAKEFILE).popt; \
	perl -pi -e "s!ROLLLIBINT!$(PWD)/$(SOURCE)/libint/lib!" $(SOURCE)/arch/$(ROLLMAKEFILE).popt; \
	perl -pi -e "s!ROLLWRAPPER!$(PWD)/$(SOURCE)/tools/hfx_tools/libint_tools!" $(SOURCE)/arch/$(ROLLMAKEFILE).popt
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE); \
	  tar xvzf ../libint-1.1.4.tar.gz; \
	  mkdir libint; \
	  cd libint-1.1.4; \
	  ./configure --with-libint-max-am=5 --with-libderiv-max-am1=4 \
	              --prefix=`pwd`/../libint; \
	  make; \
	  make install; \
	  cd ../tools/hfx_tools/libint_tools; \
	  $(CXX) -O3 -c libint_cpp_wrapper.cpp -I../../../libint/include; \
	  cd ../../../makefiles; \
	  make -j $(NCPUS) ARCH=$(ROLLMAKEFILE) VERSION=popt \
	)

install::
	mkdir -p $(ROOT)/$(PKGROOT)/bin
	mkdir -p $(ROOT)/$(PKGROOT)/test
	cp $(SOURCE)/exe/$(ROLLMAKEFILE)/cp2k.popt $(ROOT)/$(PKGROOT)/bin
	cp -r $(SOURCE)/tests/EP/* $(ROOT)/$(PKGROOT)/test/
	rm -fr $(ROOT)/$(PKGROOT)/test/CVS

clean::
	rm -rf $(SOURCE)
