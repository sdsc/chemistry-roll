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

PKGROOT = /opt/lammps
SOURCE = lammps-$(VERSION)
REDHAT.ROOT = $(PWD)/../../

-include $(ROCKSROOT)/etc/Rules.mk

ROLLFLAGS = -lgfortran

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load intel; \
    export MKL_HOME=$${MKL_ROOT}; \
    module unload intel; \
    latestModule=`module avail 2>&1 | grep -o '$(ROLLCOMPILER)/[^ (]*' | sort -V | tail -1`; \
    module load $${latestModule}; \
  fi

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI) 
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

ifeq ("$(ROLLCOMPILER)","pgi")
  ROLLFLAGS = -lpgf90 -lpgf90_rpm1 -lpgf902 -lpgf90rtl -lpgftnrtl -lrt
endif
ifeq ("$(ROLLCOMPILER)","intel")
  ROLLFLAGS = /opt/intel/composer_xe_2011_sp1.7.256/compiler/lib/intel64/libifcore.a
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

build:
	tar zxvf $(SOURCE).tar.gz
	cp patch-files/Makefile.rocks $(SOURCE)/src/MAKE/
	cp patch-files/Makefile.atc $(SOURCE)/lib/atc
	cp patch-files/Makefile.awpmd $(SOURCE)/lib/awpmd
	cp patch-files/logexc.h $(SOURCE)/lib/awpmd/ivutils/include
	cp patch-files/Makefile.meam $(SOURCE)/lib/meam
	cp patch-files/Makefile.poems $(SOURCE)/lib/poems
	cp patch-files/Makefile.reax $(SOURCE)/lib/reax
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE)/src; \
	  perl -pi -e "s!ROLLFLAGS!$(ROLLFLAGS)!" MAKE/Makefile.rocks; \
	  tar zxvf $(REDHAT.ROOT)/src/fftw-linux-x86_64.tar.gz; \
	  mv linux-x86_64 fftw; \
	  mv fftw/include/sfftw.h fftw/include/fftw.h; \
	  mv fftw/lib/libsfftw.a fftw/lib/libfftw.a; \
           make yes-class2; \
          make yes-colloid; \
          make yes-dipole; \
          make yes-fld; \
          make yes-granular; \
          make yes-kspace; \
          make yes-manybody; \
          make yes-mc; \
          make yes-meam; \
          make yes-molecule; \
          make yes-opt; \
          make yes-peri; \
          make yes-poems; \
          make yes-reax; \
          make yes-replica; \
          make yes-shock; \
          make yes-srd; \
          make yes-xtc; \
          make yes-user-reaxc; \
           cd ../lib/atc; \
          make -f Makefile.atc; \
          cp *.a ../../src; \
          cd ../awpmd; \
          make -f Makefile.awpmd; \
          cp *.a ../../src; \
          cd ../meam; \
          make -f Makefile.meam; \
          cp *.a ../../src; \
          cd ../poems; \
          make -f Makefile.poems; \
          cp *.a ../../src; \
          cd ../reax; \
          make -f Makefile.reax; \
          cp *.a ../../src; \
          cd ../../src; \
          make ROOT=lmp rocks; \
	)

install::
	mkdir -p -m 775 $(ROOT)/$(PKGROOT)/bin
	cp $(SOURCE)/src/lmp_rocks $(ROOT)/$(PKGROOT)/bin/lammps
	cp -r $(SOURCE)/examples $(ROOT)/$(PKGROOT)/examples

clean::
	rm -rf $(SOURCE)
