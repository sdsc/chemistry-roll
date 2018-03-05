#
# $Id$
#
# @Copyright@
#
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 7.0 (Manzinita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
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

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

COMPILE_FLAGS = -O2 
ifeq ("$(COMPILERNAME)","intel")
  COMPILE_FLAGS = -O2 -xHOST
else ifeq ("$(COMPILERNAME)","pgi")
  COMPILE_FLAGS = -fast
endif

$(NAME).spec: DESCRIPTION LICENSE

ROLLPY=python

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	$(MODULE_LOAD_PYTHON); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MKL); \
	  $(DESCRIBE_MPI); \
	  $(DESCRIBE_PYTHON) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo BSD and MIT > $@

build: $(SRC_DIRS)
	( \
	  $(MODULE_LOAD_CC); \
          $(MODULE_LOAD_CMAKE); \
          $(MODULE_LOAD_PYTHON); \
	  $(MODULE_LOAD_MKL); \
          export CC=mpicc; \
          export CXX=mpicxx; \
          export FC=mpif90; \
	  export MKLLIB=$${MKLHOME}/lib/intel64; \
          export LDFLAGS=-L$(PWD)/$(SOURCE_DIR)/build/fetk/lib; \
	  $(MODULE_LOAD_MPI); \
          cd $(MALOC_SOURCE_DIR); \
          mkdir ../$(SOURCE_DIR)/apbs/externals/fetk/maloc; \
          cp -r * ../$(SOURCE_DIR)/apbs/externals/fetk/maloc; \
          cd ../$(PUNC_SOURCE_DIR); \
          mkdir ../$(SOURCE_DIR)/apbs/externals/fetk/punc; \
          cp -r * ../$(SOURCE_DIR)/apbs/externals/fetk/punc; \
          cd ../$(GAMER_SOURCE_DIR); \
          mkdir ../$(SOURCE_DIR)/apbs/externals/fetk/gamer; \
          cp -r * ../$(SOURCE_DIR)/apbs/externals/fetk/gamer; \
          cd ../$(MC_SOURCE_DIR); \
          mkdir ../$(SOURCE_DIR)/apbs/externals/fetk/mc; \
          cp -r * ../$(SOURCE_DIR)/apbs/externals/fetk/mc; \
          cd ../$(SOURCE_DIR)/apbs; \
          mkdir build; \
          cd build; \
          cmake -DCMAKE_INSTALL_PREFIX=$(PKGROOT) -DENABLE_MPI=ON -DCMAKE_CXX_FLAGS="$(COMPILE_FLAGS)" -DCMAKE_CXX_COMPILER=mpicxx  -DBUILD_SHARED_LIBS=ON -DCHECK_EPSILON=ON -DENABLE_BEM=OFF -DENABLE_FETK=ON ENABLE_FAST=ON -DENABLE_INLINE=ON  -DENABLE_PYTHON=ON -DENABLE_OPENMP=ON -DBUILD_TOOLS=ON  -DBUILD_DOC=OFF .. ;  \
           $(MAKE) \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	# Bind mount appears to be required to avoid binaries that include
	# $(ROOT) and creation of /opt/apbs on build machine.
	$(PKGROOT_BIND_MOUNT)
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MKL); \
	  $(MODULE_LOAD_MPI); \
          export CC=mpicc; \
          export CXX=mpicxx; \
          export FC=mpif90; \
          cd $(SOURCE_DIR)/apbs/build; \
          $(MAKE) install \
	)
	$(INSTALL_LICENSE_FILES)
	$(PKGROOT_BIND_UMOUNT)
	cp -r $(SOURCE_DIR)/apbs/examples $(ROOT)/$(PKGROOT)
	cp -r $(SOURCE_DIR)/apbs/build/fetk/lib/* $(ROOT)/$(PKGROOT)/lib
	cp $(SOURCE_DIR)/apbs/tools/manip/psize.py $(ROOT)/$(PKGROOT)/examples/actin-dimer/
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) $(MALOC_SOURCE_DIR) $(PUNC_SOURCE_DIR) $(GAMER_SOURCE_DIR) \
                $(MC_SOURCE_DIR) pdb2pqr DESCRIPTION LICENSE

