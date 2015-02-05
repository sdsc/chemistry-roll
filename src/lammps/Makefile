# $Id$ #
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
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

ROLLWARNINGS=
LINK_LIBS := -lstdc++
ifeq ("$(COMPILERNAME)","gnu")
  LINK_LIBS += -L$${MKLLIB} -lmkl_gf_ilp64 -lmkl_gnu_thread -lmkl_core -lpthread -lgomp
else ifeq ("$(COMPILERNAME)","intel")
  LINK_LIBS += `find $${INTELHOME} -name libifcore.a | grep intel64` -mkl=sequential
  ROLLWARNINGS=-Wall -Wcheck -wd869,981,1572
else ifeq ("$(COMPILERNAME)","pgi")
  LINK_LIBS += -lpgf90 -lpgf90_rpm1 -lpgf902 -lpgf90rtl -lpgftnrtl -lrt
endif

CUDABUILD = no
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  CUDABUILD = yes
endif

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MKL); \
	  $(DESCRIBE_MPI); \
	  if test "$(CUDABUILD)" = "yes"; then \
	    $(DESCRIBE_CUDA); \
	  fi \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo GPL > $@

build: $(SRC_DIRS)
	patch $(SOURCE_DIR)/lib/gpu/Makefile.linux patch-files/Makefile.gpu.patch
	patch $(SOURCE_DIR)/lib/cuda/Makefile.common patch-files/Makefile.cuda.patch
	patch $(SOURCE_DIR)/src/MAKE/Makefile.mpi patch-files/Makefile.mpi.patch
	patch -o $(SOURCE_DIR)/lib/meam/Makefile.meam  $(SOURCE_DIR)/lib/meam/Makefile.ifort patch-files/Makefile.ifort.meam.patch
	patch -o $(SOURCE_DIR)/lib/meam/Makefile.lammps $(SOURCE_DIR)/lib/meam/Makefile.lammps.ifort patch-files/Makefile.lammps.meam.patch
	cp $(SOURCE_DIR)/lib/meam/Makefile.lammps $(SOURCE_DIR)/lib/meam/Makefile.lammps.ifort
	cp $(SOURCE_DIR)/lib/atc/Makefile.mpic++ $(SOURCE_DIR)/lib/atc/Makefile.atc 

	perl -pi -e "s!ROLLCUDA!/opt/cuda/current!" $(SOURCE_DIR)/lib/gpu/Makefile.linux
	perl -pi -e "s!ROLLCUDA!/opt/cuda/current!" $(SOURCE_DIR)/lib/cuda/Makefile.common
	perl -pi -e "s!ROLLCOMPILER!$(FC)!" $(SOURCE_DIR)/lib/meam/Makefile.meam
	
	cp $(SOURCE_DIR)/lib/awpmd/Makefile.mpicc $(SOURCE_DIR)/lib/awpmd/Makefile.awpmd
	patch -o $(SOURCE_DIR)/lib/poems/Makefile.poems $(SOURCE_DIR)/lib/poems/Makefile.icc patch-files/Makefile.poems.patch
	perl -pi -e "s!ROLLWARNINGS!$(ROLLWARNINGS)!" $(SOURCE_DIR)/lib/poems/Makefile.poems
	patch -o $(SOURCE_DIR)/lib/reax/Makefile.reax $(SOURCE_DIR)/lib/reax/Makefile.ifort patch-files/Makefile.ifort.reax.patch
	patch $(SOURCE_DIR)/lib/reax/reax_defs.h patch-files/reax_defs.h.patch
	cp $(SOURCE_DIR)/lib/reax/Makefile.lammps.ifort $(SOURCE_DIR)/lib/reax/Makefile.lammps
	perl -pi -e "s!ROLLCOMPILER!$(FC)!" $(SOURCE_DIR)/lib/reax/Makefile.reax
	patch $(SOURCE_DIR)/lib/awpmd/Makefile.lammps.installed patch-files/Makefile.lammps.awpmd.installed.patch
	patch $(SOURCE_DIR)/lib/atc/Makefile.lammps.installed patch-files/Makefile.lammps.atc.installed.patch
	patch -o $(SOURCE_DIR)/lib/colvars/Makefile.colvars $(SOURCE_DIR)/lib/colvars/Makefile.g++ patch-files/Makefile.colvars.patch
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MKL); \
	  export MKLLIB=`find $${MKLHOME}/lib/* -maxdepth 0 | head -1`; \
	  $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_CUDA); \
	  cd $(SOURCE_DIR)/src; \
	  perl -pi -e "s!LINK_LIBS!$(LINK_LIBS)!" MAKE/Makefile.mpi; \
	  perl -pi -e "s!MKL_HOME!$${MKLHOME}!" MAKE/Makefile.mpi; \
	  $(MAKE) yes-class2; \
	  $(MAKE) yes-colloid; \
	  $(MAKE) yes-dipole; \
	  $(MAKE) yes-fld; \
	  $(MAKE) yes-granular; \
	  $(MAKE) yes-kspace; \
	  $(MAKE) yes-body; \
	  $(MAKE) yes-kokkos; \
	  $(MAKE) yes-manybody; \
	  $(MAKE) yes-mc; \
	  $(MAKE) yes-meam; \
	  $(MAKE) yes-user-atc; \
	  $(MAKE) yes-user-colvars; \
	  $(MAKE) yes-user-misc; \
	  $(MAKE) yes-misc; \
	  $(MAKE) yes-user-awpmd; \
	  $(MAKE) yes-user-eff; \
	  $(MAKE) yes-user-fep; \
	  $(MAKE) yes-user-lb; \
	  $(MAKE) yes-user-molfile; \
	  $(MAKE) yes-user-phonon; \
	  $(MAKE) yes-user-sph; \
	  $(MAKE) yes-molecule; \
	  $(MAKE) yes-opt; \
	  $(MAKE) yes-peri; \
	  $(MAKE) yes-poems; \
	  $(MAKE) yes-reax; \
	  $(MAKE) yes-replica; \
	  $(MAKE) yes-shock; \
	  $(MAKE) yes-snap; \
	  $(MAKE) yes-srd; \
	  $(MAKE) yes-xtc; \
	  $(MAKE) yes-rigid; \
	  $(MAKE) yes-user-reaxc; \
	  $(MAKE) yes-user-cg-cmm; \
	  $(MAKE) yes-asphere; \
	  $(MAKE) yes-kspace; \
          cd ../lib/atc; \
	  $(MAKE) -f Makefile.atc; \
	  cp *.a ../../src; \
	  cd ../awpmd; \
	  $(MAKE) -f Makefile.awpmd; \
	  cp *.a ../../src; \
	  cd ../meam; \
	  $(MAKE) -f Makefile.meam; \
	  cp *.a ../../src; \
	  cd ../poems; \
	  $(MAKE) -f Makefile.poems; \
	  cp *.a ../../src; \
	  cd ../reax; \
	  $(MAKE) -f Makefile.reax; \
	  cp *.a ../../src; \
	  cd ../colvars; \
	  $(MAKE) -f Makefile.colvars; \
	  cp *.a ../../src; \
	  if test "$(CUDABUILD)" == "yes"; then \
	    cd ../gpu; \
	    $(MAKE) -f Makefile.mpi; \
	    cp *.a ../../src; \
	    cd ../../src; \
	    make yes-gpu; \
	    cd ../lib/cuda; \
	    $(MAKE); \
	    cp *.a ../../src; \
	  fi; \
	  cd ../../src; \
	  $(MAKE) -j 16 ROOT=lmp mpi \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 775 $(ROOT)/$(PKGROOT)/bin
	cp $(SOURCE_DIR)/src/lmp_mpi $(ROOT)/$(PKGROOT)/bin/lammps
	cp -r $(SOURCE_DIR)/examples $(ROOT)/$(PKGROOT)/
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE
