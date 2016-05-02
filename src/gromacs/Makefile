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

COMPILE_FLAGS = -fPIC -O2
ifeq ("$(COMPILERNAME)", "intel")
  COMPILE_FLAGS = -fPIC -O2 -xHost
else ifeq ("$(COMPILERNAME)", "pgi")
  COMPILE_FLAGS = -fPIC -fast
endif

CUDA=-DGMX_GPU=OFF
CUDABUILD=NO
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  CUDABUILD=YES
  CUDA = -DGMX_GPU=ON -DCUDA_TOOLKIT_ROOT_DIR=$${CUDAHOME} -DCUDA_HOST_COMPILER=$${MPIHOME}/bin/mpicc
endif

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI); \
	  $(DESCRIBE_CUDA) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo LGPLv2 > $@

build: $(SRC_DIRS)
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_CMAKE); \
	  $(MODULE_LOAD_MPI); \
          $(MODULE_LOAD_CUDA); \
	  cd $(SOURCE_DIR); \
	  mkdir build; \
	  cd build; \
	  export CC=mpicc; \
	  export CXX=mpicxx; \
          if test "CUDABUILD" = "YES"; then \
               export CUDA_TOOLKIT_ROOT_DIR=$${CUDAHOME}; \
               export CUDA_NVCC_EXECUTABLE=$${CUDAHOME}/bin/nvcc; \
               export CUDA_INCLUDE_DIRS=$${CUDAHOME}/include; \
               export CUDA_CUDART_LIBRARY=$${CUDAHOME}/lib64/libcudart.so; \
          fi; \
	  cmake .. -DGMX_BUILD_OWN_FFTW=ON \
	           -DGMX_BUILD_OWN_FFTW_URL="../../$(FFTW_PKG)" \
	           -DGMX_BUILD_OWN_FFTW_MD5=$(FFTW_MD5) \
	           -DGMX_MPI=ON \
	           -DEXTRA_C_FLAGS="$(COMPILE_FLAGS)" \
	           -DCMAKE_INSTALL_PREFIX=$(PKGROOT) $(CUDA); \
	  $(MAKE) \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	$(PKGROOT_BIND_MOUNT)
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_CMAKE); \
	  $(MODULE_LOAD_MPI); \
          $(MODULE_LOAD_CUDA); \
	  cd $(SOURCE_DIR)/build; \
	  $(MAKE) prefix=$(PKGROOT) install; \
          cd $(PKGROOT)/bin; \
          mv gmx_mpi gmx_mpi.real \
	)
	cp gmx_mpi $(PKGROOT)/bin
	$(PKGROOT_BIND_UMOUNT)
	$(INSTALL_LICENSE_FILES)
	cp -r gmxtest $(ROOT)/$(PKGROOT)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SRC_DIRS) DESCRIPTION LICENSE

