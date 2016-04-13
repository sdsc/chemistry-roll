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
FORTRANTYPE=gf
COMPILERTYPE=gnu
INTELLIBS=
GNULIBS=-lgfortran
ifeq ("$(COMPILERNAME)","intel")
  GNULIBS=
  ROLLWARNINGS=-Wall -Wcheck -wd869,981,1572
  FORTRANTYPE=intel
  COMPILERTYPE=intel
  INTELLIBS=-lifcore -lsvml -limf
endif

CUDABUILD = no
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  CUDABUILD = yes
endif


AVX_FLAG=
ifneq ("$(ROLLOPTS)", "$(subst avx2,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    AVX_FLAG = -mavx2
  else ifeq ("$(COMPILERNAME)", "intel")
    AVX_FLAG = -xcore-avx2
  endif
else ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    AVX_FLAG = -mavx
  else ifeq ("$(COMPILERNAME)", "intel")
    AVX_FLAG = -xavx
  endif
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
	mkdir -p -m 775 $(ROOT)/$(PKGROOT)/bin
	( \
          module unload gnutools; \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MKL); \
	  export MKLLIB=`find $${MKLHOME}/lib/* -maxdepth 0 | head -1`; \
	  $(MODULE_LOAD_MPI); \
# \
          patch $(SOURCE_DIR)/src/MAKE/Makefile.mpi patch-files/Makefile.mpi.patch; \
          patch $(SOURCE_DIR)/src/USER-CUDA/verlet_cuda.cpp patch-files/verlet_cuda.cpp.patch; \
          perl -pi -e "s!FORTRANTYPE!$(FORTRANTYPE)!g" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
	  perl -pi -e "s!COMPILERTYPE!$(COMPILERTYPE)!g" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
	  perl -pi -e "s!GNULIBS!$(GNULIBS)!g" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
          if test "$(COMPILERNAME)" != "intel"; then \
             perl -pi -e "s! -restrict!!" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
          fi; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
# meam \
          patch -o $(SOURCE_DIR)/lib/meam/Makefile.meam $(SOURCE_DIR)/lib/meam/Makefile.ifort patch-files/meam/Makefile.ifort.patch; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/lib/meam/Makefile.meam; \
          patch -o $(SOURCE_DIR)/lib/meam/Makefile.lammps $(SOURCE_DIR)/lib/meam/Makefile.lammps.ifort patch-files/meam/Makefile.lammps.ifort.patch; \
          perl -pi -e "s!INTELLIBS!$(INTELLIBS)!" $(SOURCE_DIR)/lib/meam/Makefile.lammps; \
# atc \
          patch -o  $(SOURCE_DIR)/lib/atc/Makefile.atc $(SOURCE_DIR)/lib/atc/Makefile.mpic++ patch-files/atc/Makefile.mpic++.patch; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/lib/atc/Makefile.atc; \
          patch $(SOURCE_DIR)/lib/atc/Makefile.lammps.installed patch-files/atc/Makefile.lammps.installed.patch; \
#awpmd \
          patch -o  $(SOURCE_DIR)/lib/awpmd/Makefile.awpmd $(SOURCE_DIR)/lib/awpmd/Makefile.mpicc patch-files/awpmd/Makefile.mpicc.patch; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/lib/awpmd/Makefile.awpmd; \
          patch $(SOURCE_DIR)/lib/awpmd/Makefile.lammps.installed patch-files/awpmd/Makefile.lammps.installed.patch; \
# poems \
          patch -o $(SOURCE_DIR)/lib/poems/Makefile.poems $(SOURCE_DIR)/lib/poems/Makefile.icc patch-files/poems/Makefile.icc.patch; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/lib/poems/Makefile.poems; \
          perl -pi -e "s!ROLLWARNINGS!$(ROLLWARNINGS)!" $(SOURCE_DIR)/lib/poems/Makefile.poems; \
# reax \
          patch -o $(SOURCE_DIR)/lib/reax/Makefile.reax $(SOURCE_DIR)/lib/reax/Makefile.ifort patch-files/reax/Makefile.ifort.patch; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/lib/reax/Makefile.reax; \
          perl -pi -e "s!ROLLCOMPILER!$(FC)!" $(SOURCE_DIR)/lib/reax/Makefile.reax; \
          patch -o $(SOURCE_DIR)/lib/reax/Makefile.lammps $(SOURCE_DIR)/lib/reax/Makefile.lammps.ifort patch-files/reax/Makefile.lammps.ifort.patch; \
          perl -pi -e "s!INTELLIBS!$(INTELLLIBS)!" $(SOURCE_DIR)/lib/reax/Makefile.lammps; \
          patch $(SOURCE_DIR)/lib/reax/reax_defs.h patch-files/reax/reax_defs.h.patch; \
          patch $(SOURCE_DIR)/src/USER-REAXC/reaxc_defs.h patch-files/reax/reaxc_defs.h.patch; \
# colvars \
          patch -o $(SOURCE_DIR)/lib/colvars/Makefile.colvars $(SOURCE_DIR)/lib/colvars/Makefile.g++ patch-files/colvars/Makefile.g++.patch; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/lib/colvars/Makefile.colvars; \
# \
	  cd $(SOURCE_DIR)/src; \
	  perl -pi -e "s!MKLLIB!$${MKLLIB}!" MAKE/Makefile.mpi; \
	  perl -pi -e "s!MKL_ROOT!$${MKL_ROOT}!" MAKE/Makefile.mpi; \
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
	  cd ../../src; \
	  if test "$(CUDABUILD)" = "yes"; then \
	    $(MODULE_LOAD_CUDA); \
            make yes-USER-CUDA; \
            cd ../lib/gpu; \
            patch Makefile.linux $(REDHAT.ROOT)/src/lammps/patch-files/gpu/Makefile.linux.patch; \
	    $(MAKE) -f Makefile.linux; \
	    cp *.a ../../src; \
	    cd ../../src; \
	    make yes-gpu; \
	    cd ../lib/cuda; \
            patch Makefile.common $(REDHAT.ROOT)/src/lammps/patch-files/cuda/Makefile.common.patch; \
            patch Makefile.lammps $(REDHAT.ROOT)/src/lammps/patch-files/cuda/Makefile.lammps.patch; \
	    $(MAKE); \
	    cp *.a ../../src; \
            cd ../../src; \
	  fi; \
	  $(MAKE) -j 16 ROOT=lmp mpi; \
	  cp lmp_mpi $(ROOT)/$(PKGROOT)/bin/lammps;  \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 775 $(ROOT)/$(PKGROOT)/bin
	cp $(SOURCE_DIR)/src/lmp_mpi $(ROOT)/$(PKGROOT)/bin/lammps
	cp -r $(SOURCE_DIR)/examples $(ROOT)/$(PKGROOT)
	cp $(SOURCE_DIR)/src/lmp_mpi $(ROOT)/$(PKGROOT)/bin/lammps
	if test "$(CUDABUILD)" = "yes"; then \
            $(MODULE_LOAD_CUDA); \
            mkdir $(ROOT)/$(PKGROOT)/lib; \
            cp $${CUDAHOME}/lib64/libcudart.so.* $(ROOT)/$(PKGROOT)/lib; \
            cp $${CUDAHOME}/lib64/libcufft.so.*  $(ROOT)/$(PKGROOT)/lib; \
        fi
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE
