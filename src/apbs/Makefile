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
include pull.mk

CC = gcc
COMPILE_FLAGS = -O2 
ifeq ("$(COMPILERNAME)","intel")
  CC = icc
  COMPILE_FLAGS = -O2 -xHOST
else ifeq ("$(COMPILERNAME)","pgi")
  CC = pgcc
  COMPILE_FLAGS = -fast
endif

ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    COMPILE_FLAGS += -mavx
  endif
endif

COMPILERSETUP =  \
  module load $(ROLLCOMPILER) || true; \
  echo === Compiler and version ===; \
  $(CC) --version

MKLSETUP = \
  module load mkl || true; \
  echo === MKL_ROOT ===; \
  echo $${MKL_ROOT}; \
  export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI)
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

MPISETUP = \
  module load $(MPIMODULE) || true; \
  echo === MPIHOME ===; \
  echo $${MPIHOME}

build: $(SRC_DIRS)
	cp test.sh $(SOURCE_DIR)/examples/actin-dimer
	( \
	  $(COMPILERSETUP); \
	  $(MKLSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE_DIR); \
	  export CFLAGS="$(COMPILE_FLAGS)"; \
	  export CXXFLAGS="$(COMPILE_FLAGS)"; \
	  export FFLAGS="$(COMPILE_FLAGS)"; \
	  if test "$(ROLLMPI)" = "openmpi"; then \
	    MPIFLAVOR=openmpi; \
	  else \
	    MPIFLAVOR=mpich2; \
	  fi; \
	  ./configure CC=mpicc F77=mpif77 \
	              --prefix=$(PKGROOT) --with-$${MPIFLAVOR}=$${MPIHOME} \
	              --with-blas="-L$${MKLLIB} -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" --with-blas-name=mkl_core; \
	  $(MAKE)  \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	# Bind mount appears to be required to avoid binaries that include
	# $(ROOT) and creation of /opt/apbs on build machine.
	-mkdir -p -m 755 $(PKGROOT)
	mount --bind $(ROOT)/$(PKGROOT) $(PKGROOT)
	( \
	  $(COMPILERSETUP); \
	  $(MKLSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE_DIR); \
	  $(MAKE) install \
	)
	umount $(PKGROOT)
	-rmdir -p $(PKGROOT)
	cp -r $(SOURCE_DIR)/examples $(ROOT)/$(PKGROOT)
	cp $(SOURCE_DIR)/tools/manip/psize.py $(ROOT)/$(PKGROOT)/examples/actin-dimer/
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)
