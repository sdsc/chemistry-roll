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
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

COMPILE_FLAGS = -O2
ifeq ("$(COMPILERNAME)", "intel")
  COMPILE_FLAGS = -O2
else ifeq ("$(COMPILERNAME)", "pgi")
  COMPILE_FLAGS = -fast
endif

MODULE_LOAD_CP2K_CUDA = $(call MODULE_LOAD_PACKAGE, $(CUDAVERSION), CUDAHOME)
DESCRIBE_CP2K_CUDA = echo built with cuda $(call GET_MODULE_VERSION, $(CUDAVERSION))

ifneq (,$(filter $(MPINAME),  mvapich intelmpi ))
  INTELMPITYPE=intelmpi
else
  INTELMPITYPE=openmpi
endif

ROLLMAKEFILE = Linux-x86-64-$(COMPILERNAME)


COMPILE_FLAGS += -I$(REDHAT.ROOT)/src/cp2k/$(SOURCE_DIR)/obj/$(ROLLMAKEFILE)/popt

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


CUDABUILD=no

ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
     CUDAVARS =  \
       CUDADEFS="-D__ACC -D__DBCSR_ACC -D__PW_CUDA"; \
       CUDALIBS="-L$${CUDAHOME}/lib64 -lcudart -lcublas -lcufft -lrt"; \
       NVCCPATH=$${CUDAHOME}/bin/nvcc
     CUDABUILD=yes
endif


$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	echo "CUDAVERSION $(CUDAVERSION)"
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI); \
	  $(DESCRIBE_FFTW); \
          if test "$(CUDABUILD)" = "yes"; then \
            $(DESCRIBE_CP2K_CUDA); \
          fi \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo -e GPLv2+ > $@

build: $(SRC_DIRS)
	cp Linux-x86-64-gnu.popt $(SOURCE_DIR)/arch
	cp Linux-x86-64-intel.popt $(SOURCE_DIR)/arch
	( \
#          if test "$(COMPILERNAME)" = "intel"; then \
#	     patch $(SOURCE_DIR)/makefiles/Makefile patch-files/Makefile.patch; \
#          fi; \
          module unload gnutools; \
	  $(MODULE_LOAD_CC); \
          module load mkl/11.3.3; \
	  $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_FFTW); \
	  perl -pi -e "s!MKL_ROOT!$${MKL_ROOT}!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!INTELMPITYPE!$(INTELMPITYPE)!g" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!ROLLFFTW!$${FFTWHOME}!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!ROLLLIBINT!$(PWD)/$(SOURCE_DIR)/libint/lib!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!LIBINTPATH!$(PWD)/$(SOURCE_DIR)/libint/lib!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!CUDADEFS!!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!CUDALIBS!!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!NVCCPATH!!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!LIBXCPATH!$(PWD)/$(SOURCE_DIR)/libxc!g" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  perl -pi -e "s!LIBPLUMEDPATH!$(PWD)/$(SOURCE_DIR)/plumed!g" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	  export CC=$(CC); \
	  export CFLAGS="$(COMPILE_FLAGS)"; \
	  export FC=$(FC); \
	  export FCFLAGS="$(COMPILE_FLAGS)"; \
	  export CXX=$(CXX); \
	  export CXXFLAGS="$(COMPILE_FLAGS)"; \
	  export FFLAGS="$(COMPILE_FLAGS)"; \
	  cd ../$(SOURCE_DIR); \
          mv ../$(LIBINT_DIR) .; \
          cd $(LIBINT_DIR); \
          if test ! -f configure; then \
            aclocal -I lib/autoconf; \
            autoconf; \
          fi; \
          ./configure --with-cc-optflags="$(COMPILE_FLAGS)" \
            --with-cxx-optflags="$(COMPILE_FLAGS)" --with-libint-max-am=5 \
            --with-libderiv-max-am1=4 --prefix=`pwd`/../libint; \
          $(MAKE); \
          $(MAKE) install; \
          cd ..; \
          mv ../$(LIBXC_DIR) .; \
          cd $(LIBXC_DIR); \
          ./configure --prefix=`pwd`/../libxc --enable-fortran --enable-shared; \
          make; \
          make install; \
          cd ..; \
          mv ../$(PLUMED_DIR) .; \
           ./configure --enable-mpi  --enable-shared --prefix=`pwd`/../plumed; \
          make; \
          make install; \
          cd ../makefiles; \
          $(MAKE) -j 16 CC=mpicc CXX=mpicxx FC=mpif90 ARCH=$(ROLLMAKEFILE) VERSION=popt; \
          mv ../exe/Linux-x86-64-$(COMPILERNAME)/*.popt ..; \
          if test "$(CUDABUILD)" = "yes"; then \
              $(MODULE_LOAD_CP2K_CUDA); \
              $(CUDAVARS); \
              cp ../../Linux-x86-64-gnu.popt ../arch; \
              cp ../../Linux-x86-64-intel.popt ../arch; \
              perl -pi -e "s!MKL_ROOT!$${MKL_ROOT}!" ../arch/$(ROLLMAKEFILE).popt; \
              perl -pi -e "s!INTELMPITYPE!$(INTELMPITYPE)!g" ../arch/$(ROLLMAKEFILE).popt; \
              perl -pi -e "s!ROLLFFTW!$${FFTWHOME}!" ../arch/$(ROLLMAKEFILE).popt; \
              perl -pi -e "s!ROLLLIBINT!$(PWD)/$(SOURCE_DIR)/libint/lib!" ../arch/$(ROLLMAKEFILE).popt; \
              perl -pi -e "s!LIBINTPATH!$(PWD)/$(SOURCE_DIR)/libint/lib!" ../arch/$(ROLLMAKEFILE).popt; \
              perl -pi -e "s!NVCCPATH!$${NVCCPATH}!" ../arch/$(ROLLMAKEFILE).popt; \
	      perl -pi -e "s!LIBXCPATH!$(PWD)/$(SOURCE_DIR)/libxc!g" ../arch/$(ROLLMAKEFILE).popt; \
  	      perl -pi -e "s!CUDADEFS!$${CUDADEFS}!" ../arch/$(ROLLMAKEFILE).popt; \
 	      perl -pi -e "s!CUDALIBS!$${CUDALIBS}!" ../arch/$(ROLLMAKEFILE).popt; \
              make realclean ARCH=$(ROLLMAKEFILE) VERSION=popt; \
              $(MAKE)CC=mpicc CXX=mpicxx FC=mpif90 ARCH=$(ROLLMAKEFILE) VERSION=popt ; \
              exes=`find ../exe/Linux-x86-64-$(COMPILERNAME) -name \*.popt -print`; \
              for exe in $${exes}; do \
                   name=`basename $${exe}`; \
                   name=`echo $${name} |sed 's/\.popt/.cuda.popt/'`; \
                   mv $${exe} ../$${name}; \
               done; \
           fi \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/lib
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/test
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/data
	cp $(SOURCE_DIR)/*.popt $(ROOT)/$(PKGROOT)/bin
	cp -r $(SOURCE_DIR)/tests/MC/*/* $(ROOT)/$(PKGROOT)/test/
	cp -r $(SOURCE_DIR)/data/* $(ROOT)/$(PKGROOT)/data
	cp -r $(SOURCE_DIR)/libxc/lib/* $(ROOT)/$(PKGROOT)/lib/
	cp -r $(PWD)/plumed/lib/* $(ROOT)/$(PKGROOT)/lib/
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE
