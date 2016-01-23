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
COMPILERTYPE=gf
COMPILERTYPE2=gcc
ifeq ("$(COMPILERNAME)", "intel")
  COMPILE_FLAGS = -O2 -xHOST
  COMPILERTYPE=intel
  COMPILERTYPE2=intel
else ifeq ("$(COMPILERNAME)", "pgi")
  COMPILERTYPE=intel
  COMPILE_FLAGS = -fast
endif

CUDAOPTS = 
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  CUDAOPTS = --enable-gpu --with-gpu-flavor=cuda-double --with-gpu-prefix=$${CUDAHOME}
endif

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI); \
          $(DESCRIBE_NETCDF); \
          $(DESCRIBE_MKL); \
	  $(DESCRIBE_CUDA) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo GPLv3  > $@

CACHE_DIR=$(REDHAT.ROOT)/cache

build: $(SRC_DIRS)
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MPI); \
          $(MODULE_LOAD_NETCDF); \
          $(MODULE_LOAD_MKL); \
	  $(MODULE_LOAD_CUDA); \
          export CC=$(CC); \
          export CXX=$(CXX); \
          export FC=$(FC); \
          export MKLLIB=`find $${MKLHOME}/lib/* -maxdepth 0 | head -1`; \
          cd $(LIBXC_DIR); \
          ./configure --prefix=$(CACHE_DIR)/libxc --enable-fortran --enable-shared; \
          make; \
          make install; \
          cd ../$(ATOMPAW_DIR); \
          ./configure --prefix=$(CACHE_DIR)/atompaw --with-libxc-incs=-I$(CACHE_DIR)/libxc/include --with-libxc-libs="$(CACHE_DIR)/libxc/lib -lxc" --with-linalg-libs="-L$${MKLLIB} -lmkl_$(COMPILERTYPE)_lp64 -lmkl_core -lmkl_sequential -lpthread -lm"; \
          make; \
          make install; \
          cd ../$(ETSF_IO_DIR); \
          ./configure --prefix=$(CACHE_DIR)/etsf_io --with-netcdf-prefix=$${NETCDFHOME}; \
          make; \
          make install; \
          cd ../$(FOX_DIR); \
          ./configure --prefix=$(CACHE_DIR)/FoX; \
          make; \
          make install; \
          export LD_LIBRARY_PATH=$(CACHE_DIR)/libxc/lib:$${LD_LIBRARY_PATH}; \
	  cd ../$(SOURCE_DIR); \
          ./configure --enable-mpi  --enable-mpi_io --with-mpi-prefix=$${MPIHOME} $(CUDAOPTS) --prefix=$(PKGROOT) --with-libxc-incs=-I$(CACHE_DIR)/libxc/include --with-libxc-libs="-L$(CACHE_DIR)/libxc/lib -lxc -lrt" --with-dft-flavor=atompaw+libxc+bigdft+wannier90 --with-atompaw-libs="-L$(CACHE_DIR)/atompaw/lib -latompaw" --with-atompaw-incs=-I$(CACHE_DIR)/atompaw/include --with-atompaw-bins=$(CACHE_DIR)/atompaw/bin --with-netcdf-incs=-I$${NETCDFHOME}/include --with-netcdf-libs="-L$${NETCDFHOME}/lib -lnetcdff -lnetcdf" --with-etsf-io-incs="-I$(CACHE_DIR)/etsf_io/include/$(COMPILERTYPE2) -I$(CACHE_DIR)/etsf_io/include" --with-etsf-io-libs="-L$(CACHE_DIR)/etsf_io/lib -letsf_io_low_level -letsf_io -letsf_io_utils -letsf_io_low_level" --with-linalg-libs="-L$${MKLLIB} -lmkl_intel_lp64 -lmkl_core -lmkl_sequential" --with-fox-incs=-I$(CACHE_DIR)/FoX/finclude --with-fox-libs=" -L$(CACHE_DIR)/FoX/lib -lFoX_common -lFoX_dom -lFoX_fsys -lFoX_sax -lFoX_utils -lFoX_wcml -lFoX_wkml -lFoX_wxml -lFoX_fsys -lFoX_common" --enable-fallbacks --with-trio-flavor=netcdf+etsf_io+fox --enable-atompaw=yes --enable-bigdft=yes --enable-etsf-io=yes --enable-fox=yes --enable-libxc=yes --enable-linalg=yes --enable-netcdf=yes --enable-wannier90=yes; \
	 $(MAKE) \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	$(PKGROOT_BIND_MOUNT)
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MPI); \
          $(MODULE_LOAD_NETCDF); \
	  $(MODULE_LOAD_CUDA); \
	  cd $(SOURCE_DIR); \
          make install; \
          cd $(CACHE_DIR)/atompaw; \
          cp -r * $(PKGROOT) \
          cd $(CACHE_DIR)/libxc/lib; \
          cp t01.files $(PKGROOT)/share/abinit-test/paral/Input; \
          cp -r * $(PKGROOT)/lib \
        ) 
	$(PKGROOT_BIND_UMOUNT)
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SRC_DIRS) $(FOX_DIR) _arch DESCRIPTION LICENSE
