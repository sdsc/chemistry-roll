
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
CACHE_DIR=$(REDHAT.ROOT)/cache
RPMS = 4
RPM_TO_BUILD = 1

COMPILE_FLAGS = -O2
ifeq ("$(COMPILERNAME)", "intel")
  COMPILE_FLAGS = -O2
else ifeq ("$(COMPILERNAME)", "pgi")
  COMPILE_FLAGS = -fast
endif
 
ROLLPY=python

MODULE_LOAD_CP2K_CUDA = $(call MODULE_LOAD_PACKAGE, $(CUDAVERSION), CUDAHOME)
DESCRIBE_CP2K_CUDA = echo built with cuda $(call GET_MODULE_VERSION, $(CUDAVERSION))

ifneq ("","$(filter mvapich intelmpi, $(findstring mvapich,$(MPINAME)) $(findstring intelmpi,$(MPINAME)))")
  INTELMPITYPE=intelmpi
else
  INTELMPITYPE=openmpi
endif

MODULE_LOAD_GNU = $(call MODULE_LOAD_COMPILER,gnu,gcc)

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

CUDAVARS=\#
NVCCPATH=""
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
     CUDAVARS =  \
       CUDALIBS="-L$${CUDAHOME}/lib64 -lcuda -lcudart -lcublas -lcufft -lnvrtc"; \
       NVCCPATH="$${CUDAHOME}/bin/nvcc"; \
       CUDADEFS="-D__ACC -D__DBCSR_ACC -D__PW_CUDA"
     CUDABUILD=yes
endif


$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	echo "CUDAVERSION $(CUDAVERSION)"
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
          $(DESCRIBE_PYTHON); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MKL); \
	  $(DESCRIBE_MPI); \
          $(DESCRIBE_BOOST); \
          if test "$(CUDABUILD)" = "yes"; then \
            $(DESCRIBE_CP2K_CUDA); \
          fi \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo -e GPLv2+ > $@

build: $(SRC_DIRS)
	( \
          if test "$(RPM_TO_BUILD)" = "1"; then \
            $(MODULE_LOAD_PYTHON); \
            $(MODULE_LOAD_GNU); \
	    $(MODULE_LOAD_CC); \
	    $(MODULE_LOAD_MKL); \
	    $(MODULE_LOAD_MPI); \
            $(MODULE_LOAD_BOOST); \
	    cp Linux-x86-64-gnu.popt $(SOURCE_DIR)/arch; \
	    cp Linux-x86-64-intel.popt $(SOURCE_DIR)/arch; \
            cp configure-get.sh $(LIBINT_DIR); \
#           ln -s `which python3` python; \
#           export PATH=`pwd`:${PATH}; \
	    perl -pi -e "s!MKL_ROOT!$${MKL_ROOT}!g" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	    perl -pi -e "s!INTELMPITYPE!$(INTELMPITYPE)!g" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	    perl -pi -e "s!LIBINTPATH!$(PWD)/$(SOURCE_DIR)/libint!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	    perl -pi -e "s!CUDADEFS!!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	    perl -pi -e "s!CUDALIBS!!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	    perl -pi -e "s!NVCCPATH!!" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	    perl -pi -e "s!LIBXCPATH!$(PWD)/$(SOURCE_DIR)/libxc!g" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	    perl -pi -e "s!LIBXSMMPATH!$(PWD)/$(SOURCE_DIR)/libxsmm!g" $(SOURCE_DIR)/arch/$(ROLLMAKEFILE).popt; \
	    cd $(SOURCE_DIR); \
	    export CC=$(CC); \
	    export FC=$(FC); \
	    export CXX=$(CXX); \
            mv ../$(LIBINT_DIR) .; \
            cd $(LIBINT_DIR); \
            sh ./configure-get.sh libint; \
            if test "$(COMPILERNAME)" = "intel"; then \
               patch configure-libint-hsw.sh  ../../patch-files/configure-libint-hsw.sh.patch; \
               sh ./configure-libint-hsw.sh; \
            elif test "$(COMPILERNAME)" = "gnu"; then \
               patch configure-libint-hsw-gnu.sh  ../../patch-files/configure-libint-hsw-gnu.sh.patch; \
               sh ./configure-libint-hsw-gnu.sh; \
            fi; \
            $(MAKE) -j `nproc --ignore=2`; \
            $(MAKE) install; \
	    export CFLAGS="$(COMPILE_FLAGS)"; \
	    export FCFLAGS="$(COMPILE_FLAGS)"; \
	    export CXXFLAGS="$(COMPILE_FLAGS)"; \
	    export FFLAGS="$(COMPILE_FLAGS)"; \
            export OMPI_FCFLAGS=$${FCFLAGS}; \
            export OMPI_CFLAGS=$${CFLAGS}; \
            export OMPI_CXXFLAGS=$${CXXFLAGS}; \
            cd ..; \
            mv ../$(LIBXC_DIR) .; \
            cd $(LIBXC_DIR); \
            ./configure --prefix=`pwd`/../libxc --enable-fortran --enable-shared; \
            make -j `nproc --ignore=2`; \
            make install; \
            cd ..; \
            mv ../$(LIBXSMM_DIR) . ; \
            cd $(LIBXSMM_DIR); \
            make PREFIX=`pwd`/../libxsmm install; \
            cd ..; \
            $(MAKE) -j `nproc --ignore=2` CC=`which mpicc` CXX=`which mpicxx` FC=`which mpif90` ARCH=$(ROLLMAKEFILE) VERSION=popt; \
            mv exe/Linux-x86-64-$(COMPILERNAME)/*.popt .; \
            if test "$(CUDABUILD)" = "yes"; then \
              $(MODULE_LOAD_CP2K_CUDA); \
              $(CUDAVARS); \
              declare -A gpus; \
              gpus+=( ["K40"]="no" ["K80"]="no" ["P100"]="no" ["V100"] = "no" ); \
	      for capability in `echo $(CUDA_CAPABILITIES) | sed 's/,/ /g'`; do \
                if test $${capability} -lt 37 -a $${capability} -ge 35; then \
                    if test "$${gpus["K40"]}" = "yes"; then \
                       continue; \
                    else \
                       export GPUVER=K40; \
                       gpus["K40"]="yes"; \
                    fi; \
                elif test $${capability} -ge 37 -a $${capability} -lt 60; then \
                    if test "$${gpus["K80"]}" = "yes"; then \
                       continue; \
                    else \
                       export GPUVER=K80; \
                       gpus["K80"]="yes"; \
                    fi; \
                elif test $${capability}  -ge 60 -a $${capability} -lt 70; then \
                    if test "$${gpus["P100"]}" = "yes"; then \
                       continue; \
                    else \
                       export GPUVER=P100; \
                       gpus["P100"]="yes"; \
                    fi; \
                elif test $${capability}  -ge 70 -a $${capability} -lt 75; then \
                    if test "$${gpus["V100"]}" = "yes"; then \
                       continue; \
                    else \
                       export GPUVER=V100; \
                       gpus["V100"]="yes"; \
                    fi; \
                else \
                    echo "NO COMPATIBLE CP2K CUDA OPTION FOUND FOR CUDA CAPABILITY $${capability}"; \
                    continue; \
                fi;  \
                cp ../Linux-x86-64-gnu.popt arch; \
                cp ../Linux-x86-64-intel.popt arch; \
	        perl -pi -e "s!MKL_ROOT!$${MKL_ROOT}!g" arch/$(ROLLMAKEFILE).popt; \
                perl -pi -e "s!INTELMPITYPE!$(INTELMPITYPE)!g" arch/$(ROLLMAKEFILE).popt; \
	        perl -pi -e "s!LIBINTPATH!$(PWD)/$(SOURCE_DIR)/libint!" arch/$(ROLLMAKEFILE).popt; \
	        perl -pi -e "s!CUDADEFS!$${CUDADEFS}!" arch/$(ROLLMAKEFILE).popt; \
	        perl -pi -e "s!CUDALIBS!$${CUDALIBS}!" arch/$(ROLLMAKEFILE).popt; \
	        perl -pi -e "s!NVCCPATH!$${NVCCPATH}!" arch/$(ROLLMAKEFILE).popt; \
	        perl -pi -e "s!LIBXCPATH!$(PWD)/$(SOURCE_DIR)/libxc!g" arch/$(ROLLMAKEFILE).popt; \
	        perl -pi -e "s!LIBXSMMPATH!$(PWD)/$(SOURCE_DIR)/libxsmm!g" arch/$(ROLLMAKEFILE).popt; \
                make realclean ARCH=$(ROLLMAKEFILE) VERSION=popt; \
                $(MAKE) -j `nproc --ignore=2` CC=`which mpicc` CXX=`which mpicxx` FC=`which mpif90` ARCH=$(ROLLMAKEFILE) VERSION=popt; \
                exes=`find exe/Linux-x86-64-$(COMPILERNAME) -name \*.popt -print`; \
                for exe in $${exes}; do \
                     name=`basename $${exe}`; \
                     name=`echo $${name} |sed "s/\.popt/.cuda.$${GPUVER}.popt/"`; \
                     mv $${exe} $${name}; \
                 done; \
                 rm -f *graph*cuda*.popt *unittest*cuda*.popt *shell*cuda*.popt; \
               done; \
               cd $(REDHAT.ROOT)/src/cp2k; \
               cp -r $${CUDAHOME}/samples/1_Utilities/deviceQuery deviceQuery.dir; \
               patch deviceQuery.dir/Makefile patch-files/Makefile.deviceQuery.patch; \
               cd deviceQuery.dir; \
               make clean; \
               make INCLUDES=-I$${CUDAHOME}/samples/common/inc; \
             fi; \
             cd $(PWD); \
             mkdir -p $(CACHE_DIR)/cp2k/bin; \
             mkdir -p $(CACHE_DIR)/cp2k/lib; \
             mkdir -p $(CACHE_DIR)/cp2k/test; \
             mkdir -p $(CACHE_DIR)/cp2k/data; \
             cp $(SOURCE_DIR)/*.popt $(CACHE_DIR)/cp2k/bin; \
             cp -r $(SOURCE_DIR)/tests/MC/*/* $(CACHE_DIR)/cp2k/test; \
             cp -r $(SOURCE_DIR)/data/* $(CACHE_DIR)/cp2k/data; \
             cp -r $(SOURCE_DIR)/libxc/lib/* $(CACHE_DIR)/cp2k/lib; \
             cp cp2k.cuda.popt $(CACHE_DIR)/cp2k/bin; \
             cp  $(REDHAT.ROOT)/src/cp2k/deviceQuery $(CACHE_DIR)/cp2k/bin; \
             perl -pi -e "s!PKGROOT!$(PKGROOT)!g" $(CACHE_DIR)/cp2k/bin/cp2k.cuda.popt; \
          fi \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	( \
	  cd $(CACHE_DIR)/cp2k; \
	  find . -type f | sort | perl -e 'for(my $$i=0;<>;$$i++){chomp and `/bin/cp --parents "$$_" $(ROOT)/$(PKGROOT)/` if $$i%$(RPMS)+1 == $(RPM_TO_BUILD);}'; \
	)
	( \
	  if test "$(RPM_TO_BUILD)" = "1"; then \
	    for rpm in `seq 2 $(RPMS)`; do \
	      echo $(MAKE) NAME=$(NAME)_$$rpm RPM_TO_BUILD=$$rpm rpm; \
	      $(MAKE) NAME=$(NAME)_$$rpm RPM_TO_BUILD=$$rpm rpm; \
	    done; \
	    $(INSTALL_LICENSE_FILES); \
          fi \
        )
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) deviceQuery.dir $(LIBINT_DIR) $(LIBXC_DIR) $(LIBSMM_DIR) DESCRIPTION LICENSE
