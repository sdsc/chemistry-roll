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

CACHE_DIR=$(REDHAT.ROOT)/cache

ROLLWARNINGS=
FORTRANTYPE=gf
COMPILERTYPE=gnu
INTELLIBS=
INTELLIBS2=
GNULIBS=-lgfortran
ifeq ("$(COMPILERNAME)","intel")
  GNULIBS=
  ROLLWARNINGS=-Wall -Wcheck -wd869,981,1572
  FORTRANTYPE=intel
  COMPILERTYPE=intel
  INTELLIBS=-lifcore -lsvml -limf -lintlc
  INTELLIBS2=-liomp5
endif

CUDABUILD = no
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  CUDABUILD = yes
endif

MODULE_LOAD_LAMMPS_CUDA = $(call MODULE_LOAD_PACKAGE, $(CUDAVERSION), CUDAHOME)
DESCRIBE_LAMMPS_CUDA = echo built with cuda $(call GET_MODULE_VERSION, $(CUDAVERSION))

GPUS=37 60

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
	    $(DESCRIBE_LAMMPS_CUDA); \
	  fi \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo GPL > $@

build: cpu $(GPUS)
	@echo "::: Package $(NAME) build complete :::"


cpu: $(SRC_DIRS)
	mkdir -p $(CACHE_DIR)/lammps/bin
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MKL); \
	  export MKLLIB=`find $${MKLHOME}/lib/* -maxdepth 0 | head -1`; \
	  $(MODULE_LOAD_MPI); \
# \
          patch $(SOURCE_DIR)/src/MAKE/Makefile.mpi patch-files/Makefile.mpi.patch; \
          perl -pi -e "s!FORTRANTYPE!$(FORTRANTYPE)!g" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
	  perl -pi -e "s!COMPILERTYPE!$(COMPILERTYPE)!g" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
	  perl -pi -e "s!GNULIBS!$(GNULIBS)!g" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
          if test "$(COMPILERNAME)" != "intel"; then \
             perl -pi -e "s! -restrict!!" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
          fi; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
          perl -pi -e "s!INTELLIB!$(INTELLIBS2)!" $(SOURCE_DIR)/src/MAKE/Makefile.mpi; \
# meam \
          patch -o $(SOURCE_DIR)/lib/meam/Makefile.meam $(SOURCE_DIR)/lib/meam/Makefile.ifort patch-files/meam/Makefile.ifort.patch; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/lib/meam/Makefile.meam; \
# atc \
          patch $(SOURCE_DIR)/lib/meam/Makefile.lammps.ifort patch-files/meam/Makefile.lammps.ifort.patch; \
          perl -pi -e "s!INTELLIBS!$(INTELLIBS)!" $(SOURCE_DIR)/lib/meam/Makefile.lammps.ifort; \
          patch -o  $(SOURCE_DIR)/lib/atc/Makefile.atc $(SOURCE_DIR)/lib/atc/Makefile.mpic++ patch-files/atc/Makefile.mpic++.patch; \
          perl -pi -e "s!ROLLAVX!$(AVX_FLAG)!" $(SOURCE_DIR)/lib/atc/Makefile.atc; \
          patch $(SOURCE_DIR)/lib/atc/Makefile.lammps.installed patch-files/atc/Makefile.lammps.installed.patch; \
          patch $(SOURCE_DIR)/lib/atc/Matrix.h patch-files/atc/Matrix.h.patch; \
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
          patch $(SOURCE_DIR)/lib/kokkos/Makefile.kokkos patch-files/kokkos/Makefile.kokkos.patch; \
          patch -o $(SOURCE_DIR)/src/MAKE/OPTIONS/Makefile.kokkos_cuda  $(SOURCE_DIR)/src/MAKE/OPTIONS/Makefile.kokkos_cuda_openmpi patch-files/kokkos/Makefile.kokkos_cuda.patch; \
          patch $(SOURCE_DIR)/lib/gpu/Makefile.linux patch-files/gpu/Makefile.linux.patch; \
          perl -pi -e "s!MKLLIB!$${MKLLIB}!" $(SOURCE_DIR)/src/MAKE/OPTIONS/Makefile.kokkos_cuda; \
          perl -pi -e "s!COMPILERTYPE!$(COMPILERTYPE)!g" $(SOURCE_DIR)/src/MAKE/OPTIONS/Makefile.kokkos_cuda; \
          perl -pi -e "s!GNULIBS!$(GNULIBS)!g" $(SOURCE_DIR)/src/MAKE/OPTIONS/Makefile.kokkos_cuda; \
          perl -pi -e "s!INTELLIB!$(INTELLIBS2)!" $(SOURCE_DIR)/src/MAKE/OPTIONS/Makefile.kokkos_cuda; \
          perl -pi -e "s!FORTRANTYPE!$(FORTRANTYPE)!g" $(SOURCE_DIR)/src/MAKE/OPTIONS/Makefile.kokkos_cuda; \
          if [[ $(MPINAME) == *"openmpi"* ]]; then \
               perl -pi -e "s!MPITYPE!OMPI_CXX!" $(SOURCE_DIR)/src/MAKE/OPTIONS/Makefile.kokkos_cuda; \
          elif [[ $(MPINAME) == *"mvapich2"* ]]; then \
                  perl -pi -e "s!MPITYPE!MPICH_CXX!" $(SOURCE_DIR)/src/MAKE/OPTIONS/Makefile.kokkos_cuda; \
          fi; \
# \
	  cd $(SOURCE_DIR)/src; \
	  perl -pi -e "s!MKLLIB!$${MKLLIB}!" MAKE/Makefile.mpi; \
	  perl -pi -e "s!MKL_ROOT!$${MKL_ROOT}!" MAKE/Makefile.mpi; \
	  $(MAKE) yes-class2; \
	  $(MAKE) yes-colloid; \
	  $(MAKE) yes-dipole; \
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
	  $(MAKE) yes-rigid; \
	  $(MAKE) yes-user-reaxc; \
	  $(MAKE) yes-user-cg-cmm; \
	  $(MAKE) yes-asphere; \
          $(MAKE) yes-user-drude; \
          $(MAKE) yes-user-fep; \
          $(MAKE) yes-qeq; \
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
	  $(MAKE) -j 16 ROOT=lmp mpi; \
	  mv lmp_mpi $(CACHE_DIR)/lammps/bin/lammps \
        )

$(GPUS):
	 if test "$(CUDABUILD)" = "yes"; then \
test=1

testit:
             case $@ in \
                 K80) GPUNAME=k80; \
                   ;; \
                 P100) GPUNAME=p100; \
                   ;; \
             esac; \
	     $(MODULE_LOAD_CC); \
	     $(MODULE_LOAD_MKL); \
	     $(MODULE_LOAD_MPI); \
             $(MODULE_LOAD_LAMMPS_CUDA); \
             cd $(SOURCE_DIR)/src; \
             make yes-gpu; \
             cd ../lib/gpu; \
             cp Makefile.linux Makefile.linux.tmp; \
             perl -pi -e "s!CUDA_CAPABILITY!$@!g" Makefile.linux; \
	     $(MAKE) -f Makefile.linux; \
	     cp *.a ../../src; \
             cd ../../src;  \
             cp *.a ../../src; \
	     $(MAKE) -j 16 ROOT=lmp kokkos_cuda; \
    	     mv lmp_kokkos_cuda  $(CACHE_DIR)/lammps/bin/lammps.$${GPUNAME}.cuda; \
             cd ../lib/kokkos; \
             cp Makefile.linux.tmp Makefile.linux; \
             cd ../gpu; \
             rm -f *cubin*; \
             rm -f *.o; \
             rm -f libgpu.a; \
             rm -f nvc_get_devices; \
             cd ../src; \
             rm -f libgpu.a; \
             rm -f *gpu*; \
	  fi

install::
	mkdir -p -m 775 $(ROOT)/$(PKGROOT)/bin
	cp $(CACHE_DIR)/lammps/bin/* $(ROOT)/$(PKGROOT)/bin
	cp -r $(SOURCE_DIR)/examples $(ROOT)/$(PKGROOT)
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE
