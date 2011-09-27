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
#

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif
ifndef ROLLMPI
  ROLLMPI = openmpi
endif

PKGROOT = /opt/gromacs
SOURCE = gromacs-$(VERSION)
REDHAT.ROOT = $(PWD)/../../

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER); \
  fi

ifeq ("$(ROLLNETWORK)", "eth")
  MPI= $(ROLLMPI)
else
  MPI= $(ROLLMPI)_$(ROLLNETWORK)
endif

MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPI); \
  fi; \
  export MPI_HOME=`which mpicxx | perl -pe 's!/bin/.*!!'`; \
  if test -z "$${MPI_HOME}"; then \
    export MPI_HOME=/opt/$(ROLLMPI); \
  fi; \
  echo Using MPI from $${MPI_HOME}; \
  export PATH=$${PATH}:$${MPI_HOME}/bin; \
  export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${MPI_HOME}/lib

CXX = g++
CC=gcc
FCC = f77
ifeq ("$(ROLLCOMPILER)", "intel")
  CXX = icpc        
  CC= icc
  FCC = ifort
endif
ifeq ("$(ROLLCOMPILER)", "pgi")
  CC= pgcc
  CXX = pgCC
  FCC = pgf90
endif

build:
	tar zxvf $(SOURCE).tar.gz
	tar zxvf gmxtest.tar.gz
	tar zxvf fftw-3.2.2.tar.gz
	( \
	   cd fftw-3.2.2; \
	  $(COMPILERSETUP); \
           ./configure --prefix=$(REDHAT.ROOT)/src/gromacs/fftw-3.2.2/build --enable-openmp --enable-single CFLAGS=-fPIC FFLAGS=-fPIC CC=$(CC) CXX=$(CXX) f77=$(FCC); \
           make; \
           make install; \
        )
	( \
	  cd $(SOURCE); \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  ./configure --prefix=$(ROOT)/$(PKGROOT) --enable-mpi --with-fft=fftw3 CC=$(CC) F77=$(FCC) CXX=$(CXX) CFLAGS=-I$(REDHAT.ROOT)/src/gromacs/fftw-3.2.2/build/include LDFLAGS=-L$(REDHAT.ROOT)/src/gromacs/fftw-3.2.2/build/lib; \
	  make; \
	)

install::
	(\
          cd $(SOURCE); \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
          make install; \
        )
	cp -r gmxtest $(ROOT)/$(PKGROOT)

clean::
	rm -rf $(SOURCE) fftw-3.2.2 gmxtest