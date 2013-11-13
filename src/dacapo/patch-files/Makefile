# This Makefile works together with GNU make.
# GNU make can be obtained from any FTP archive near you.
# The Danish FTP archive currently has the GNU make in the file:
#    ftp://ftp.denet.dk/pub/gnu/make-3.75.tar.gz

# The concept used is to compile for each "arch" in a separate
# subdirectory OBJECTDIR (arch_serial,arch_mpi).
# Either serial or message-passing versions may be compiled.
MKLPATH=ROLLMKL
FFTWPATH=ROLLFFTW2
NETCDF = ROLLNETCDF
MPI_DIR=ROLLMPI

default:
	@echo	'Usage: gmake [arch] [ MP=MP_library ]'
	@echo	'where arch is one of'
	@echo
	@echo	'generic		(should compile on all machines, '
	@echo   '                        see notes on FFTW and blas)'
	@echo   'pglinux                (Portland Group pgf90 compiler on Linux)'
	@echo   'intellinux             (Intel ifort compiler version >=9.1 on Linux)'
	@echo   'itanium                (Intel ifort compiler version >=9.0 on SGI Itanium2 Linux)'
	@echo   'intelmac               (Intel ifort Fortran compiler + MKL, >= 9.x on Mac OS X)'
	@echo   'pathscale              (pathscale pathf90 compiler on Linux)'
	@echo   'g95linux               (GNU g95 compiler on Linux)'
	@echo   'gfortran_fnosecond_underscore (gcc-gfortran-4.1.1 compiler on CentOS)'
	@echo   'gfortran_fsecond_underscore (gcc-gfortran-4.2.1 compiler on Ubuntu)'
	@echo	'sun_ultra		(Sun ultra-1 or ultra-2)'
	@echo	'sun_ss10		(Sun sparcstation 10/20)'
	@echo	'ibm_power3		(RS/6000 power3 node)'
	@echo	'ibm_power2_wide	(RS/6000 wide power2 node: 590,591,...)'
	@echo	'ibm_power2_thin	(RS/6000 thin/thin2 power2 node: 390,...)'
	@echo	'ibm_power		(Older RS/6000 power cpus: 580,...)'
	@echo	'ibm_ppc		(RS/6000 powerPC)'
	@echo	'vpp500			(Fujitsu VPP-500)'
	@echo   'cray                   (CRAY UNICOS)'
	@echo   'sgi                    (Silicon Graphics n32 ABI)'
	@echo   'alpha                  (Digital Alpha)'
	@echo
	@echo	'and the supported MP_libraries so far are serial and mpi'
	@echo	'(default is MP_library=serial).'

#####################################################################
#
# Common definitions
#

# Name of this Makefile:
MAKEFILE = Makefile

# Message-passing library type.  Default is "none", i.e., MP=serial:
MP = serial

# Should swap-file be used for the qrad array (should be set for this version)
QRAD_SWAP_OPT = -DQRAD_SWAP

# Source directory is one level above:
SRCDIR = ..

# Directory for libraries and .o files
OBJECTDIR = ${ARCH}_${MP}

COMMONBINS =  generate_kpoints.o  read_structure_netcdf.o bastr.o  chdop.o  efertr.o  mach.o \
       fexcop.o genbop.o nlproj.o orthop.o wfinop.o density_mixing.o \
       setuop.o ionmov.o ion_conjgrad.o gen_coord.o auxmod.o potion.o fft3d2.o \
       forloc.o calvps.o inidir.o eferop.o eisdia.o \
       dipole.o kptana.o resmin.o \
       corec.o pulay.o davidson.o qrutil.o \
       gen_orthop.o \
       qvan2.o setuspot.o us_calcqr.o \
       us_hpsi.o us_newd.o ylmr2.o gk_sort.o \
       rmm_diss.o wfcinit.o potinit.o us_force.o erfc.o \
       eigsolve.o subproj.o bfgs.o \
       tmp_read.o matrix_utilities.o \
       fftdimensions.o ewald_module.o dacapo.o update_netcdf_history_module.o \
       double_grid.o real_nonlocal.o applyh.o angula.o stress.o madelung.o \
       blochlmodule.o external_pot_module.o  addusdens.o pbe.o pbeunsp.o \
       pw.o pwunsp.o  symana.o mulcen.o gen_hamiltonian_matrix.o

SERIALBINS =  run_context.o van_us_data_module.o ${COMMONBINS} damden.o libtos.o

PARALLELBINS = run_context.o van_us_data_module.o par_functions.o ${COMMONBINS} damden.o libtos.o  ms.o mpi.o par_getwf.o

# Make-directory command
MKDIR = mkdir -p
# Netcdf include dir
NETCDFINC = -I$(NETCDF)/include


# If a efficient FFT library is not available (like ESSL on IBM RS/6000
# or DXML on Digital Alpha) dacapo can be linked together with
# FFTW Fast Fourier Transform library.
# Download and compile the FTTW library (version 2.1.3) from www.fftw.org
# (remember to add -lfftw to LIBS_arch)
USEFFTW=-DFFTW

#####################################################################
#
# Machine-specific rules
#
# ---------------------- Generic  ---------------------
# To compiled using 'gmake generic' requires a version
# of the BLAS library and version 2.1.3 of the FFTW library.
# In the GENERIC section of mach.F a time function can be added,
# and the flush function can be changed.
# The library for netcdf libnetcdf.a must be copied to
#     src/netcdf/include/generic/libnetcdf.a

GENERIC_DEFINES =  ${USEFFTW} ${QRAD_SWAP_OPT} -DGENERIC
GENERIC_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
GENERIC_OPT = -fast
endif
GENERIC_FC = $(DACAPO_FC)
ifndef DACAPO_FC
GENERIC_FC = mpif90
endif
GENERIC_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
GENERIC_FC90 = mpif90
endif
GENERIC_FFLAGS = -byteswapio -Msecond_underscore -g77libs
LIBS_generic=-lblas -lfftw
LIBS_generic_mpi= -L/usr/share/mpi/include/  -lmpich
GENERIC_MPIDIR=/home/data/lhansen/MPICH/linux/mpich-1.2.1
GENERIC_MPI_BINDIR=/home/data/lhansen/MPICH/linux/mpich-1.2.1/bin

generic:
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=generic \
        FC=$(GENERIC_FC) FC90=$(GENERIC_FC90) F90FF='-M free ' MPIFC='${GENERIC_MPI_BINDIR}/mpif90 -f90=$(GENERIC_FC90)' MPI_LIBDIR=${GENERIC_MPIDIR} \
        FFLAGS="${GENERIC_OPT} ${GENERIC_FFLAGS} ${GENERIC_DEFINES}" \
        DEFINES="${GENERIC_DEFINES}" \
        LIBS= ${LIBS_generic} \
        INCLUDES='-I${SRCDIR} -I../netcdf/generic -I../netcdf' \
        EXTRABINS='fargc.o'

#
# ---------------------- pglinux : Portland Group pgf90 running on Linux -------------
#
PGLINUX_DEFINES =  ${USEFFTW} ${QRAD_SWAP_OPT} -DPGLINUX

DACAPO_FC=mpif90
PGLINUX_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
PGLINUX_OPT = -fast
endif
PGLINUX_FC = $(DACAPO_FC)
ifndef DACAPO_FC
PGLINUX_FC = mpif90
endif
PGLINUX_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
PGLINUX_FC90 = mpif90
endif
PGLINUX_NOPT=-g
PGLINUX_FFLAGS = -byteswapio
BLASLAPACK=-L${MKLPATH} -lmkl_intel_lp64 -lmkl_core -lmkl_sequential -lpthread -lm

# using blas, lapack, fftw and netcdf from appropriate environment variables
LIBS_pglinux= ${BLASLAPACK} -L${NETCDF}/lib -lnetcdf -lnetcdff -L${FFTWPATH}/lib -lfftw

# using LAM-MPI
MPI_LIBDIR=$(MPIDIR)/lib
MPI_INCLUDEDIR=$(MPIDIR)/include
LIBS_pglinux_mpi='-L${MPI_LIBDIR} -llamf77mpi'
PGLINUX_MPIDIR="${MPI_LIBDIR}"
PGLINUX_MPI_INCLUDE="${MPI_INCLUDEDIR}"
ifndef MPI_INCLUDEDIR
PGLINUX_MPI_INCLUDE="${MPI_LIBDIR}/../include"
endif
PGLINUX_MPI_BINDIR="${MPI_BINDIR}"
ifndef MPI_BINDIR
PGLINUX_MPI_BINDIR="${MPI_LIBDIR}/../bin"
endif

pglinux:
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=pglinux \
	FC=$(PGLINUX_FC) FC90=$(PGLINUX_FC90) F90FF='-Mfree ' MPIFC='${PGLINUX_MPI_BINDIR}/mpif77' MPI_LIBDIR='${PGLINUX_MPIDIR}' \
	FFLAGS="${PGLINUX_OPT} ${PGLINUX_FFLAGS} ${PGLINUX_DEFINES}" \
        FNOPT="${PGLINUX_NOPT}" \
	DEFINES="${PGLINUX_DEFINES}" \
	LIBS='${LIBS_pglinux}' \
	INCLUDES='-I${SRCDIR} -I${PGLINUX_MPI_INCLUDE} -I../netcdf/pglinux -I$(NETCDF)/include' \
	EXTRABINS='fargc.o'

#
# ---------------------- intellinux : Intel ifort running on Linux -------------
#
# Information at http://www.intel.com/cd/software/products/asmo-na/eng/219690.htm
# Intel support at http://www.intel.com/cd/ids/developer/asmo-na/eng/support/index.htm

INTELLINUX_DEFINES =  ${USEFFTW} ${QRAD_SWAP_OPT} -DINTELLINUX
# Use -xN for highest optimization on Pentium-4,
# for other Intel CPUs use a different -x? flag (see "man ifort").
INTELLINUX_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
INTELLINUX_OPT = -O3
endif
INTELLINUX_FC = mpif90
ifndef DACAPO_FC
INTELLINUX_FC = mpif90
endif
INTELLINUX_FC90 = mpif90
ifndef DACAPO_FC90
INTELLINUX_FC90 = mpif90
endif
# INTELLINUX_OPT = -fast
# INTELLINUX_OPT = -g -O0 -check all -ftrapuv -traceback
# Suppress warnings.  Convert binary files from/to big_endian
INTELLINUX_FFLAGS = -cm -w -convert big_endian
# Endian-ness is relevant to read binary Vanderbilt pseudo-potential files,
# which are "fortran unformatted", IEEE big-endian.
#	http://www.physics.rutgers.edu/~dhv/uspp/uspp-736/Doc/FORMAT
# Select the appropriate Intel MKL library for your CPU (32, 64 or em64t):
# The MKL-FFTW2 documentation is in http://www.intel.com/software/products/mkl/docs/fftw2xmkl_notes.htm
LIBS_intellinux_mpi=-L${NETCDF}/lib -lnetcdf -lnetcdff $(FFTWPATH)/lib/libfftw.a -L${MKLPATH} -lmkl_intel_lp64 -lmkl_core -lmkl_sequential -lpthread -lm
MPI_LIBDIR=$(MPI_DIR)/lib
MPI_INCLUDEDIR=$(MPI_DIR)/include
INTELLINUX_MPIDIR=${MPI_LIBDIR}
INTELLINUX_MPI_INCLUDE="${MPI_INCLUDEDIR}"
ifndef MPI_INCLUDEDIR
INTELLINUX_MPI_INCLUDE="${MPI_LIBDIR}/../include"
endif
INTELLINUX_MPI_BINDIR="${MPI_BINDIR}"
ifndef MPI_BINDIR
INTELLINUX_MPI_BINDIR="${MPI_LIBDIR}/../bin"
endif

intellinux:
	@ echo Creating the intellinux_${MP}/work.pcl file for the ifort compiler
	@if [ ! -d intellinux_${MP} ]; then \
	    ${MKDIR} intellinux_${MP}; \
	fi
	@ echo 'work.pc' > intellinux_${MP}/work.pcl
	@ echo '../netcdf/intellinux/work.pc' >> intellinux_${MP}/work.pcl
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=intellinux \
	FC=$(INTELLINUX_FC) FC90=$(INTELLINUX_FC90) F90FF='-FR' MPIFC='${INTELLINUX_MPI_BINDIR}/mpif90' MPI_LIBDIR=${INTELLINUX_MPIDIR} \
	FFLAGS="${INTELLINUX_OPT} ${INTELLINUX_FFLAGS} ${INTELLINUX_DEFINES}" \
	DEFINES="${INTELLINUX_DEFINES}" \
	LIBS="${LIBS_intellinux}" \
	INCLUDES='-I${SRCDIR} -I${INTELLINUX_MPI_INCLUDE} -I../netcdf/intellinux -I../netcdf' \
	EXTRABINS='fargc.o'

#
# ---------------------- itanium : Intel ifort running on Linux -------------
#
# by Vesa for SGI Itanium 2 Altix using the Intel ifort compiler
# Thanks to Karoliina Honkala <karoliina.honkala@phys.jyu.fi>
#
ITANIUM_DEFINES =  ${USEFFTW} ${QRAD_SWAP_OPT} -DINTELLINUX
# Itanium 3 specific options
ITANIUM_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
ITANIUM_OPT = -tpp2 -ftz
endif
ITANIUM_FC = $(DACAPO_FC)
ifndef DACAPO_FC
ITANIUM_FC = ifort
endif
ITANIUM_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
ITANIUM_FC90 = ifort
endif
# Pseudopotentials are big endian
ITANIUM_FFLAGS =  -convert big_endian
# LAPACK from MKL (builtin lapack/blas removed from this Makefile)
# self-complied fftw libraries, also using Intel icc and ifort
# mpi library from SGI's proprietory MPT package
LIBS_itanium=  -lmkl_lapack -lmkl  -lfftw3 -lfftw -lmpi
LIBPATHS=-L$(HOME)/lib/ -L/opt/intel/mkl/9.0/lib/64/ -L/opt/sgi-sq/mpt/1.13-sgi403r1/usr/lib

ITANIUM_MPIDIR=$LIBRARY_PATH

itanium:
	@ echo Creating the itanium_${MP}/work.pcl file for the ifort compiler
	@if [ ! -d itanium_${MP} ]; then \
            ${MKDIR} itanium_${MP}; \
	    fi
	    @ echo 'work.pc' > itanium_${MP}/work.pcl
	    @ echo '../netcdf/itanium/work.pc' >> itanium_${MP}/work.pcl
	    @ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=itanium FC90=${ITANIUM_FC} F90FF='-FR' \
	    MPIFC=${ITANIUM_FC} \
	    MPI_LIBDIR=${ITANIUM_MPIDIR} \
	    FFLAGS="${ITANIUM_OPT} ${ITANIUM_FFLAGS} ${ITANIUM_DEFINES}" \
	    DEFINES="${ITANIUM_DEFINES}" \
	    LIBS= ${LIBS_itanium} \
	    INCLUDES='-I${SRCDIR} -I../netcdf/itanium -I../netcdf' \
	    EXTRABINS='fargc.o'


#
# ---------------------- intelmac ------------------------
#
# MacOS X on Intel CPUs
# Thanks to Michael Sternberg <sternberg@anl.gov>
# o Intel Fortran, C, and MKL 9.x
#    docs - web:
#	http://www.intel.com/software/products/mkl/docs/Getting_Started_mac.htm
#	http://www.intel.com/software/products/mkl/docs/mkluse_mac.htm
#	http://www.intel.com/software/products/mkl/docs/fftw2xmkl_notes.htm
#
#    docs - local:
#	file:///Library/Frameworks/Intel_MKL.framework/Versions/Current/doc/Getting_Started.htm
#	file:///Library/Frameworks/Intel_MKL.framework/Versions/Current/doc/mkluse.htm
#	file:///Library/Frameworks/Intel_MKL.framework/Versions/Current/doc/fftw2xmkl_notes.htm
#
#    provides:
#	- tuned BLAS, Lapack
#	- FFTW interface (source only; needs to be compiled and installed)
#
#    NB: static linking is *not* supported.
#
# o NetCDF from DarwinPorts/MacPorts
#	- needs explicit fortran support
#	  (added variant: +ifort - upstream patch pending)
#	- verified version 3.6.0-p1
#
# o original FFTW not needed (interface provided by MKL)
#	- C-Fortran interface not supported for ifort
#	  (best bet would be to try cloning DEC fortran config)

MKL_PATH = /Library/Frameworks/Intel_MKL.framework/Libraries/32
MKL_KERNEL = mkl_ia32
MKL_LAPACK = mkl_lapack

# The FFTW interface of MKL is not installed by default. To install (as root):
#    cd /Library/Frameworks/Intel_MKL.framework/Versions/Current/interfaces/fftw2xf
#    make lib32 [PRECISION=MKL_DOUBLE]

INTELMAC_LAPACK = -L$(MKL_PATH) -lfftw2xf_intel -l$(MKL_LAPACK) -l$(MKL_KERNEL) -lguide -lpthread
INTELMAC_NETCDF = -L/opt/local/lib -lnetcdf

INTELMAC_DEFINES = ${USEFFTW} ${QRAD_SWAP_OPT} -DINTELLINUX

## For all supported Fortran options, see "ifort -help"
#
#	-O1    optimize for maximum speed, but disable some optimizations which
#	-O2    enable optimizations (DEFAULT)
#	-O3    enable -O2 plus more aggressive optimizations that may not improve
#	-O0    disable optimizations
#	-O     same as -O2
#	-fast  enable -O3 -ipo -no-prec-div -mdynamic-no-pic
#
#	-cm        suppress all comment messages
#	-w         disable all warnings
#	           (n=1, DEFAULT, same as -warn general)
#	-w90, -w95 suppress messages about use of non-standard Fortran
#	-convert <keyword>
#              specify the format of unformatted files containing numeric data
#              keywords:  big_endian, cray, ibm, little_endian, native, vaxd,
#
# Endian-ness is relevant to read binary Vanderbilt pseudo-potential files,
# which are "fortran unformatted", IEEE big-endian.
#	http://www.physics.rutgers.edu/~dhv/uspp/uspp-736/Doc/FORMAT
#
INTELMAC_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
INTELMAC_OPT = -fast
endif
INTELMAC_FC = $(DACAPO_FC)
ifndef DACAPO_FC
INTELMAC_FC = intel
endif
INTELMAC_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
INTELMAC_FC90 = ifort
endif
INTELMAC_FFLAGS = -convert big_endian -cm -w

# TODO: build and test MPI
# -L/usr/local/mpi  -lmpich
# INTELMAC_MPIDIR=/opt/local/mpi
#
## no need for LIBS_${ARCH} here; supply to LIBS directly

INTELMAC_MPI_LIBDIR=${MPI_LIBDIR}
INTELMAC_MPI_INCLUDE="${MPI_INCLUDEDIR}"
ifndef MPI_INCLUDEDIR
INTELMAC_MPI_INCLUDE="${MPI_LIBDIR}/../include"
endif
INTELMAC_MPI_BINDIR="${MPI_BINDIR}"
ifndef MPI_BINDIR
INTELMAC_MPI_BINDIR="${MPI_LIBDIR}/../bin"
endif

intelmac:
	@${MAKE} -f ${MAKEFILE} ${MP} \
	    ARCH=intelmac \
	    FC=$(INTELMAC_FC) \
	    FC90=$(INTELMAC_FC90) \
	    F90FF='-FR' \
	    MPIFC='${INTELMAC_MPI_BINDIR}/mpif90 -f90=$(INTELMAC_FC90)' \
	    MPI_LIBDIR=${INTELMAC_MPIDIR} \
	    FFLAGS="${INTELMAC_OPT} ${INTELMAC_FFLAGS} ${INTELMAC_DEFINES}" \
	    DEFINES="${INTELMAC_DEFINES}" \
	    LIBS="$(INTELMAC_LAPACK) $(INTELMAC_NETCDF)" \
	    INCLUDES='-I${SRCDIR} -I${INTELMAC_MPI_INCLUDE} -I../netcdf/intelmac -I../netcdf -I/opt/local/include' \
	    EXTRABINS='fargc.o'


# ---------------------- pathscale -------------
PATHSCALE_DEFINES =  ${USEFFTW} ${QRAD_SWAP_OPT} -DPGLINUX

PATHSCALE_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
PATHSCALE_OPT = -Ofast
endif
PATHSCALE_FC = $(DACAPO_FC)
ifndef DACAPO_FC
PATHSCALE_FC = pathf90
endif
PATHSCALE_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
PATHSCALE_FC90 = pathf90
endif
PATHSCALE_FFLAGS = -byteswapio -cpp -Wp,-P
PATHSCALE_NOOPT= -g

# using MPI library specified by MPI_LIBDIR environment variable
PATHSCALE_MPIDIR=${MPI_LIBDIR}
PATHSCALE_MPI_INCLUDE="${MPI_INCLUDEDIR}"
ifndef MPI_INCLUDEDIR
PATHSCALE_MPI_INCLUDE="${MPI_LIBDIR}/../include"
endif
PATHSCALE_MPI_BINDIR="${MPI_BINDIR}"
ifndef MPI_BINDIR
PATHSCALE_MPI_BINDIR="${MPI_LIBDIR}/../bin"
endif

# using acml blas,fftw and netcdf
#LIBS_pathscale= ${BLASLAPACK} -L${MPI_LIBDIR}/lib64 -L${NETCDF} -lnetcdf -L${FFTW} -lfftw
LIBS_pathscale= ${BLASLAPACK} -L${MPI_LIBDIR} ${NETCDF}/libnetcdf.a ${FFTW}/libfftw.a

pathscale:
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=pathscale \
	FC=$(PATHSCALE_FC) FC90=$(PATHSCALE_FC90) F90FF="-freeform" MPIFC="${PATHSCALE_MPI_BINDIR}/mpif90" MPI_LIBDIR=${PATHSCALE_MPIDIR} \
	FFLAGS="${PATHSCALE_OPT} ${PATHSCALE_FFLAGS} ${PATHSCALE_DEFINES}" \
	FNOPT="${PATHSCALE_NOOPT}" \
	DEFINES="${PATHSCALE_DEFINES}" \
	LIBS="${LIBS_pathscale}" \
	INCLUDES="-I${SRCDIR} -I${PATHSCALE_MPI_INCLUDE} -I../netcdf/pathscale -I../netcdf" \
	EXTRABINS="fargc.o"

# ---------------------- g95 Linux ----------------------------------------------------

# Thanks to Karoliina Honkala <karoliina.honkala@phys.jyu.fi>
G95LINUX_DEFINES =  ${USEFFTW} ${QRAD_SWAP_OPT} -DINTELLINUX -DGFORTRAN
G95LINUX_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
G95LINUX_OPT = -O3
endif
G95LINUX_FC = $(DACAPO_FC)
ifndef DACAPO_FC
G95LINUX_FC = g95
endif
G95LINUX_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
G95LINUX_FC90 = g95
endif
G95LINUX_FFLAGS = -fPIC -fendian=big
LIBS_g95linux= ${BLASLAPACK} ${NETCDF}/libnetcdf.a ${FFTW}/libfftw.a

LIBS_g95linux_mpi=
G95LINUX_MPIDIR=${MPI_LIBDIR}
G95LINUX_MPI_INCLUDE="${MPI_INCLUDEDIR}"
ifndef MPI_INCLUDEDIR
G95LINUX_MPI_INCLUDE="${MPI_LIBDIR}/../include"
endif
G95LINUX_MPI_BINDIR="${MPI_BINDIR}"
ifndef MPI_BINDIR
G95LINUX_MPI_BINDIR="${MPI_LIBDIR}/../bin"
endif

g95linux:
	@ echo Creating the g95linux_${MP}/work.pcl file for the gnu Fortran-95 compiler
	@if [ ! -d g95linux_${MP} ]; then \
		${MKDIR} g95linux_${MP}; \
	fi
	@ echo 'work.pc' > g95linux_${MP}/work.pcl
	@ echo '../netcdf/g95linux/work.pc' >> g95linux_${MP}/work.pcl
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=g95linux \
	FC=$(G95LINUX_FC) FC90=$(G95LINUX_FC90) F90FF='-ffree-form -freal-loops' MPIFC='${G95LINUX_MPI_BINDIR}/mpif90 -f90=$(G95LINUX_FC90)' MPI_LIBDIR=${G95LINUX_MPIDIR} \
	FFLAGS="${G95LINUX_OPT} ${G95LINUX_FFLAGS} ${G95LINUX_DEFINES}" \
	DEFINES="${G95LINUX_DEFINES}" \
	LIBS="${LIBS_g95linux}" \
	INCLUDES="-I${SRCDIR} -I${G95LINUX_MPI_INCLUDE} -I../netcdf/g95linux -I../netcdf" \
	EXTRABINS='fargc.o'


# ---------------------- gfortran_fnosecond_underscore Linux ----------------------------------------------------

# Based on g95 profile by Karoliina Honkala <karoliina.honkala@phys.jyu.fi>
# and gfortrangentoo profile by Jakob Schiotz <schiotz@fysik.dtu.dk>
# compile dacapo, netcdf and fftw using gfortran or you will
# have to deal with -f[no-]second-underscore issues!
GFORTRAN_FNOSECOND_UNDERSCORE_DEFINES =  ${USEFFTW} ${QRAD_SWAP_OPT} -DINTELLINUX -DGFORTRAN
GFORTRAN_FNOSECOND_UNDERSCORE_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
GFORTRAN_FNOSECOND_UNDERSCORE_OPT = -O3
endif
GFORTRAN_FNOSECOND_UNDERSCORE_FC = $(DACAPO_FC)
ifndef DACAPO_FC
GFORTRAN_FNOSECOND_UNDERSCORE_FC = gfortran
endif
GFORTRAN_FNOSECOND_UNDERSCORE_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
GFORTRAN_FNOSECOND_UNDERSCORE_FC90 = gfortran
endif
GFORTRAN_FNOSECOND_UNDERSCORE_NOOPT = -O0
GFORTRAN_FNOSECOND_UNDERSCORE_FFLAGS = -fno-second-underscore -fPIC -fconvert=big-endian -frecord-marker=4
##LIBS_gfortran_fnosecond_underscore= ${BLASLAPACK} -L${NETCDF} -lnetcdf -L${FFTW} -lfftw
LIBS_gfortran_fnosecond_underscore= ${BLASLAPACK} ${NETCDF}/libnetcdf.a ${FFTW}/libfftw.a

LIBS_gfortran_fnosecond_underscore_mpi=
GFORTRAN_FNOSECOND_UNDERSCORE_MPIDIR=${MPI_LIBDIR}
GFORTRAN_FNOSECOND_UNDERSCORE_MPI_INCLUDE="${MPI_INCLUDEDIR}"
ifndef MPI_INCLUDEDIR
GFORTRAN_FNOSECOND_UNDERSCORE_MPI_INCLUDE="${MPI_LIBDIR}/../include"
endif
GFORTRAN_FNOSECOND_UNDERSCORE_MPI_BINDIR="${MPI_BINDIR}"
ifndef MPI_BINDIR
GFORTRAN_FNOSECOND_UNDERSCORE_MPI_BINDIR="${MPI_LIBDIR}/../bin"
endif


gfortran_fnosecond_underscore:
	@ echo Creating the gfortran_fnosecond_underscore_${MP}/work.pcl file for the gfortran compiler
	@if [ ! -d gfortran_fnosecond_underscore_${MP} ]; then \
		${MKDIR} gfortran_fnosecond_underscore_${MP}; \
	fi
	@ echo 'work.pc' > gfortran_fnosecond_underscore_${MP}/work.pcl
	@ echo '../netcdf/gfortran_fnosecond_underscore/work.pc' >> gfortran_fnosecond_underscore_${MP}/work.pcl
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=gfortran_fnosecond_underscore \
	FC=$(GFORTRAN_FNOSECOND_UNDERSCORE_FC) FC90=$(GFORTRAN_FNOSECOND_UNDERSCORE_FC90) F90FF='-ffree-form' MPIFC='${GFORTRAN_FNOSECOND_UNDERSCORE_MPI_BINDIR}/mpif90 -f90=$(GFORTRAN_FNOSECOND_UNDERSCORE_FC90)' MPI_LIBDIR=${GFORTRAN_FNOSECOND_UNDERSCORE_MPIDIR} \
	FFLAGS="${GFORTRAN_FNOSECOND_UNDERSCORE_OPT} ${GFORTRAN_FNOSECOND_UNDERSCORE_FFLAGS} ${GFORTRAN_FNOSECOND_UNDERSCORE_DEFINES}" \
        FNOPT="${GFORTRAN_FNOSECOND_UNDERSCORE_NOOPT}" \
	DEFINES="${GFORTRAN_FNOSECOND_UNDERSCORE_DEFINES}" \
	LIBS="${LIBS_gfortran_fnosecond_underscore}" \
	INCLUDES="-I${SRCDIR} -I${GFORTRAN_FNOSECOND_UNDERSCORE_MPI_INCLUDE} -I../netcdf/gfortran_fnosecond_underscore -I../netcdf"\
	EXTRABINS='fargc.o'

# ---------------------- gfortran_fsecond_underscore Linux ----------------------------------------------------

# Based on g95 profile by Karoliina Honkala <karoliina.honkala@phys.jyu.fi>
# and gfortrangentoo profile by Jakob Schiotz <schiotz@fysik.dtu.dk>
# compile dacapo, netcdf and fftw using gfortran or you will
# have to deal with -f[no-]second-underscore issues!
GFORTRAN_FSECOND_UNDERSCORE_DEFINES =  ${USEFFTW} ${QRAD_SWAP_OPT} -DINTELLINUX -DGFORTRAN
GFORTRAN_FSECOND_UNDERSCORE_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
GFORTRAN_FSECOND_UNDERSCORE_OPT = -O3
endif
GFORTRAN_FSECOND_UNDERSCORE_FC = $(DACAPO_FC)
ifndef DACAPO_FC
GFORTRAN_FSECOND_UNDERSCORE_FC = gfortran
endif
GFORTRAN_FSECOND_UNDERSCORE_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
GFORTRAN_FSECOND_UNDERSCORE_FC90 = gfortran
endif
GFORTRAN_FSECOND_UNDERSCORE_NOOPT = -O0
GFORTRAN_FSECOND_UNDERSCORE_FFLAGS = -fsecond-underscore -fPIC -fconvert=big-endian -frecord-marker=4
##LIBS_gfortran_fsecond_underscore= ${BLASLAPACK} -L${NETCDF} -lnetcdf -L${FFTW} -lfftw
LIBS_gfortran_fsecond_underscore= ${BLASLAPACK} ${NETCDF}/libnetcdf.a ${FFTW}/libfftw.a

LIBS_gfortran_fsecond_underscore_mpi=
GFORTRAN_FSECOND_UNDERSCORE_MPIDIR=${MPI_LIBDIR}
GFORTRAN_FSECOND_UNDERSCORE_MPI_INCLUDE="${MPI_INCLUDEDIR}"
ifndef MPI_INCLUDEDIR
GFORTRAN_FSECOND_UNDERSCORE_MPI_INCLUDE="${MPI_LIBDIR}/../include"
endif
GFORTRAN_FSECOND_UNDERSCORE_MPI_BINDIR="${MPI_BINDIR}"
ifndef MPI_BINDIR
GFORTRAN_FSECOND_UNDERSCORE_MPI_BINDIR="${MPI_LIBDIR}/../bin"
endif


gfortran_fsecond_underscore:
	@ echo Creating the gfortran_fsecond_underscore_${MP}/work.pcl file for the gfortran compiler
	@if [ ! -d gfortran_fsecond_underscore_${MP} ]; then \
		${MKDIR} gfortran_fsecond_underscore_${MP}; \
	fi
	@ echo 'work.pc' > gfortran_fsecond_underscore_${MP}/work.pcl
	@ echo '../netcdf/gfortran_fsecond_underscore/work.pc' >> gfortran_fsecond_underscore_${MP}/work.pcl
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=gfortran_fsecond_underscore \
	FC=$(GFORTRAN_FSECOND_UNDERSCORE_FC) FC90=$(GFORTRAN_FSECOND_UNDERSCORE_FC90) F90FF='-ffree-form' MPIFC='${GFORTRAN_FSECOND_UNDERSCORE_MPI_BINDIR}/mpif90 -f90=$(GFORTRAN_FSECOND_UNDERSCORE_FC90)' MPI_LIBDIR=${GFORTRAN_FSECOND_UNDERSCORE_MPIDIR} \
	FFLAGS="${GFORTRAN_FSECOND_UNDERSCORE_OPT} ${GFORTRAN_FSECOND_UNDERSCORE_FFLAGS} ${GFORTRAN_FSECOND_UNDERSCORE_DEFINES}" \
        FNOPT="${GFORTRAN_FSECOND_UNDERSCORE_NOOPT}" \
	DEFINES="${GFORTRAN_FSECOND_UNDERSCORE_DEFINES}" \
	LIBS="${LIBS_gfortran_fsecond_underscore}" \
	INCLUDES="-I${SRCDIR} -I${GFORTRAN_FSECOND_UNDERSCORE_MPI_INCLUDE} -I../netcdf/gfortran_fsecond_underscore -I../netcdf"\
	EXTRABINS='fargc.o'

# ------------------- Sun Microsystems -----------------------------
# Assuming Sun Fortran version 4.0 (?) with Ultra-SPARC features:
SUN_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
SUN_OPT = -dalign -g -Qoption fpp -P
endif
SUN_FC = $(DACAPO_FC)
ifndef DACAPO_FC
SUN_FC = f90
endif
SUN_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
SUN_FC90 = f90
endif

LIBS_sun_ultra=-xlic_lib=sunperf -xlibmopt -L/gbar/bohr/home1/fys/fyslbh/fftw/lib -lfftw
LIBS_sun_ultra_mpi= -xlic_lib=sunperf -xlibmopt -L/opt/SUNWhpc/lib -lmpi

ULTRA_DEFINES = -DSUN -DULTRA  ${USEFFTW} ${QRAD_SWAP_OPT}
sun_ultra:
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=sun_ultra FC=$(SUN_FC) \
        FC90=$(SUN_FC90)  F90FF=' -free ' MPIFC=/opt/SUNWhpc/bin/mpf90  FFLAGS='${SUN_OPT} ${ULTRA_DEFINES}' \
        DEFINES="${ULTRA_DEFINES}" \
        INCLUDES='-I${SRCDIR} -I../netcdf -M../netcdf/sun_ultra' \
        MPI_LIBDIR='/opt/SUNWhpc'

        # EXTRABINS='../binobj/sun_ultra/zfft.o' MPI_LIBDIR='/opt/SUNWhpc'



SS10_DEFINES = -DSUN -DSS10
sun_ss10:
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=sun_ss10 FC=$(SUN_FC) \
        FC90=$(SUN_FC90)    F90FF=' -freeform ' MPIFC=$(SUN_FC) \
        FFLAGS="${SUN_OPT}  -depend ${SS10_DEFINES} -xtarget=ss10/hs11 \
                -Qoption fpp -P -xarch=v8" \
        DEFINES="${SS10_DEFINES}" \
        INCLUDES='-I${SRCDIR} -I../netcdf -M../netcdf/sun_ultra'  \
        EXTRABINS=hyperfft.o

# ------------------- IBM RS/6000 ----------------------------------
ibm_power3:
	@ ${MAKE} -f ${MAKEFILE} ibm MP=${MP} ARCH=$@ \
		DEFINES='-DIBM ${QRAD_SWAP_OPT}' QARCH='-qarch=pwr3 -qtune=pwr3'

ibm_power2_wide:
	@ ${MAKE} -f ${MAKEFILE} ibm MP=${MP} ARCH=$@ \
		DEFINES='-DIBM_POWER2_WIDE  ${QRAD_SWAP_OPT}' QARCH='-qarch=pwr2'

ibm_power2_thin:
	@ ${MAKE} -f ${MAKEFILE} ibm MP=${MP} ARCH=$@ \
		DEFINES='-DIBM_POWER2_THIN  ${QRAD_SWAP_OPT}' QARCH='-qarch=pwr2 -qtune=pwr2s'

ibm_power:
	@ ${MAKE} -f ${MAKEFILE} ibm MP=${MP} ARCH=$@ \
		DEFINES='-DIBM_POWER' QARCH='-qarch=pwr'

ibm_ppc:
	@ ${MAKE} -f ${MAKEFILE} ibm MP=${MP} ARCH=$@ \
		DEFINES='-DIBM_PPC' QARCH='-qarch=ppc'

# IBM XLF version 3.2 compiler flags:

# Checking procedure interface and common blocks
# XLF_CHECK = -qextchk
# Listing and cross-reference
# XLF_CROSSREF = -qxref=full -qattr
# XLF_LISTING = -qsource -qlistopt ${XLF_CROSSREF}
# Compiling for "gprof" performance profiling:
# XLF_PROFILE = -pg
# Compiling for "tprof" performance profiling:
# XLF_PROFILE = -qlist -g -d -bnoquiet
# Debug code:
# XLF_DEBUG = -WF,-DDEBUG -WF,-DALL_RESIDUALS  -WF,-DDEBUG3 -WF,-DDEBUG2
# XLF_DEBUG = -WF,-DALL_RESIDUALS   -WF,-DREALPROJ
XLF_DEBUG = -WF,-DALL_RESIDUALS
# Floating-point optimizations:

# flags for debugging the code
# XLF_OPT = -g -d -C  -qspillsize=32000 -qfloat=fltint:rsqrt:hssngl -qalias=noaryovrlp:std:nointptr -qdpc=e -qnosave -bmaxdata:0x80000000 -bmaxstack:0x80000000

# optimizing flags for jensen (large memory)
# XLF_OPT = -d -O3  -qspillsize -qfloat=fltint:rsqrt:hssngl -qalias=noaryovrlp:std:nointptr -qdpc=e -qnosave  -bmaxdata:0x80000000 -bmaxstack:0x80000000

# optimizing flags for camp
# On Power3 and PowerPC omit the "hssngl" option
XLF_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
XLF_OPT = -O3 -d -qspillsize -qfloat=fltint:rsqrt:hssngl -qalias=noaryovrlp:std:nointptr -qdpc=e -qnosave
endif
XLF_FC = $(DACAPO_FC)
ifndef DACAPO_FC
XLF_FC = xlf
endif
XLF_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
XLF_FC90 = xlf90
endif

# Special case for F90-modules on the AIX GPFS filesystem
# (see http://hpcf.nersc.gov/computers/SP/f90modules.html)
# XLF_GPFS = -qmoddir=$(TMPDIR) -I$(TMPDIR)

XLF_FLAGS = ${XLF_OPT} ${XLF_PROFILE} ${XLF_LISTING} ${XLF_DEBUG} ${XLF_GPFS}
# Define ESSL if you have the IBM ESSL library installed:
ESSL = -DESSL

# XLF special: prepend "-WF," to the -D flags:
PREPEND_WF = 's/[	]*-D/ -WF,-D/g'
LIBS_ibm_power2_thin=-lesslp2 -lmass
LIBS_ibm_power2_wide=-lesslp2 -lmass
LIBS_ibm_power3=     -lessl -lmass

ibm:
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=${ARCH} \
	FC=$(XLF_FC) FC90=$(XLF_FC90) MPIFC=mpxlf MPI_LIBDIR=/usr/lpp/ppe.poe \
	FFLAGS="${QARCH} ${XLF_FLAGS} \
		`echo ${ESSL} ${DEFINES} | sed ${PREPEND_WF} `" \
	DEFINES='${ESSL} ${DEFINES}' \
	INCLUDES='-I${SRCDIR} -WF,-I${SRCDIR} ${NETCDFINC} -WF,${NETCDFINC}' CPP_PREFIX=-WF, \
	INLINE=-Q+exchns,corlns,corgns,gcorns,EXCH,CORLSD,GCOR,CORGGA,exch1,cor1lsd,gcor1,cor1gga,cor2gga

# ---------------------- CRAY UNICOS ---------------------
# CRAY_LISTING = -rm
# CRAY_OPT = -O3,inline2 -dp
CRAY_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
CRAY_OPT = -dp
endif
CRAY_FC = $(DACAPO_FC)
ifndef DACAPO_FC
CRAY_FC = f90
endif
CRAY_DEFINES = -DCRAY -DBLAS

cray:
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=unicos \
	FC=$(CRAY_FC) \
	FFLAGS="${CRAY_OPT} ${CRAY_LISTING} -F ${CRAY_DEFINES}" \
	DEFINES="${CRAY_DEFINES}" \
	INCLUDES='-I ${SRCDIR}'
#       INLINE=-Q+exchns,corlns,corgns,gcorns,EXCH,CORLSD,GCOR,CORGGA,exch1,cor1lsd,gcor1,cor1gga,cor2gga


# ------------------- SGI n32 ABI ----------------------------------
SGI_DEFINES = -DSGI -DBLAS
#SGI_OPT = -mips4 -Ofast=ip27 -n32 -r10000 -IPA:aggr_cprop:echo=ON -OPT:IEEE_arithmetic=3
#SGI_OPT = -g -64 -r10000 -static
#SGI_OPT = -g -n32 -r10000
# SGI_OPT = -Ofast=ip27 -64 -r10000 -IPA:aggr_cprop:echo=ON -OPT:IEEE_arithmetic=3
SGI_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
SGI_OPT = -C -g -64 -r10000 -OPT:IEEE_arithmetic=3 -MP:check_reshape=on
endif
SGI_FC = $(DACAPO_FC)
ifndef DACAPO_FC
SGI_FC = f90
endif
SGI_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
SGI_FC90 = f90
endif
LIBS_sgi= -lcomplib.sgimath -lblas -lfastm -lm
LIBS_sgi_mpi= -lmpi
CPP_sgi= /usr/lib/cpp -P ${SGI_DEFINES}

sgi:
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=sgi FC=$(SGI_FC) \
	FC90=$(SGI_FC90) F90FF='-freeform' MPIFC=$(SGI_FC)           \
	FFLAGS="-cpp -Wp,-P ${SGI_OPT} ${SGI_DEFINES}" \
	DEFINES="${SGI_DEFINES} " \
	INCLUDES='-I${SRCDIR} -I../netcdf -I../netcdf/sgi' \
	INLINE=-INLINE:must=exchns,corlns,corgns,gcorns,EXCH,CORLSD,GCOR,CORGGA,exch1,cor1lsd,gcor1,cor1gga,cor2gga


# ---------------------- Digital Alpha ---------------------
ALPHA_DEFINES = -DDXML -DDECALPHA ${QRAD_SWAP_OPT} ${USEFFTW}
# ALPHA_DEFINES = -DDXML -DDECALPHA ${QRAD_SWAP_OPT}
# Warning: Must compile ms.F with -O0 or -g (bug in DEC Fortran 5.1)
ALPHA_NOOPT= -O0 -g
ALPHA_NOOPT= -g
# ALPHA_OPT = -O4 -arch host -fast -tune host -transform_loops -d
# V5.3-1120 need -switch noexpand_complex to handle optimization
ALPHA_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
ALPHA_OPT = -O4 -arch host -fast -tune host -transform_loops -d -switch noexpand_complex
endif
ALPHA_FC = $(DACAPO_FC)
ifndef DACAPO_FC
ALPHA_FC = f90
endif
ALPHA_FC90 = $(DACAPO_FC90)
ifndef DACAPO_FC90
ALPHA_FC90 = f90
endif
# ALPHA_OPT = -O4 -arch host -tune host -d
# ALPHA_OPT = -C -g -d  -K
# ALPHA_OPT = -g -arch host
ALPHA_FFLAGS = -automatic -convert big_endian -assume byterecl -warn truncated_source
LIBS_alpha=-ldxml -lfftw ${SRCDIR}/lapack/${ARCH}/liblapack.a
# LIBS_alpha=-ldxml

alpha: ${SRCDIR}/lapack/${ARCH}/liblapack.a
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=alpha \
	FC=$(ALPHA_FC) FC90=$(ALPHA_FC90) F90FF='-free' MPIFC=mpif90 MPI_LIBDIR=/usr/local/mpi \
	FFLAGS="-cpp -Wp,-P ${ALPHA_OPT} ${ALPHA_FFLAGS} ${ALPHA_DEFINES}" \
        FNOPT="${ALPHA_NOOPT}" \
	DEFINES="${ALPHA_DEFINES}" \
	LIBS= ${LIBS_alpha} \
	INCLUDES='-I${SRCDIR} -I../netcdf/alpha -I../netcdf' \

# ------------------- Fujitsu VPP-500 vector-parallel --------------
# You may find GNU make in /usr/local/parmacs/bin/fujitsu-vpp500/gnumake
# if the PARMACS library has been installed.
#
# -Oe,-P for optimization without possible evaluation of statements
#        beyond unfulfilled if-statement
# -Ad to promote real*4 to real*8 but not real*8 to real*16
# -Ab to allow for arrays being undefined in intermediate calling levels
VPP_OPT = $(FFLAGS_OPT)
ifndef FFLAGS_OPT
VPP_OPT = -Oe,-P -Ab
endif
VPP_FC = $(DACAPO_FC)
ifndef DACAPO_FC
VPP_FC = 'frtpx'
endif
# The last item (,100) is the max. number of statements
VPP_INLINE = -Ne,exchns,corlns,corgns,gcorns,EXCH,CORLSD,GCOR,CORGGA,exch1,cor1lsd,gcor1,cor1gga,cor2gga,100
# -Wv,-m2 to add to listing the reasons for non-vectorization
# Procedure call debugging:
#  -Da : argument validation check
#         (argument consistency between caller and called subroutine)
#  -Ds : subscript validation(array range) check
#  -Du : undefined variable check
# VPP_DEBUG = -Dasu
# -Pdlt for getting list
VPP_LISTING = -Z$(@:.o=.list) -Pdilt -Wv,-m2 -Eielpu

VPP_FFTLIB = /home/vpp/group12/hammer/lib/libfft.a

# This is for compiling into "new type loadmodule" that works also on 1 GB nodes
VPP_NEW1GB = -Wl,-J,-K
VPP_LDFLAGS = -J -K

VPP_FFLAGS = ${VPP_OPT} ${VPP_NEW1GB} ${VPP_LISTING} ${VPP_DEBUG}

vpp500:
	@ ${MAKE} -f ${MAKEFILE} ${MP} ARCH=vpp500 FC=$(VPP_FC) \
	FFLAGS="${VPP_FFLAGS}" \
	DEFINES='-DVPP500' CFLAGS='-DVPP500' \
	INCLUDES=-I${SRCDIR} \
	INLINE="${VPP_INLINE}" \
	EXTRABINS="fft3dj.o machjp.o hostname.o ${VPP_FFTLIB}"

#####################################################################
#
# Rules for serial or message-passing versions
#

# Copy the Makefile to the OBJECTDIR:
${OBJECTDIR}/${MAKEFILE}: ${MAKEFILE}
#	Catch errors: first make sure that ARCH is set.
	@if [ -z "${ARCH}" ]; then \
	    echo Error: ARCH not specified; \
	    ${MAKE} -f ${MAKEFILE} default; \
	    exit 1; \
	fi
	@if [ ! -d ${OBJECTDIR} ]; then \
	    ${MKDIR} ${OBJECTDIR}; \
	fi
	cp -p $< ${OBJECTDIR}

serial: ${OBJECTDIR}/${MAKEFILE}
	@echo
	@echo Making $@ version in directory ${OBJECTDIR}
	@echo
	@(cd ${OBJECTDIR}; ${MAKE} -f ${MAKEFILE} dacapo.run \
	FC=${FC} FFLAGS='${FFLAGS}' DEFINES='${DEFINES}' \
	INCLUDES='${INCLUDES}' LIBS='${LIBS}' \
	ALLBINS='${SERIALBINS} ${EXTRABINS}' \
	INLINE='${INLINE}'  )

mpi: ${OBJECTDIR}/${MAKEFILE}
	@echo
	@echo Making $@ version in directory ${OBJECTDIR}
	@echo
		@(cd ${OBJECTDIR}; ${MAKE} -f ${MAKEFILE} dacapo.run \
		LIBS='${LIBS}'  \
		FC='${MPIFC}' \
		FFLAGS='${FFLAGS} ${CPP_PREFIX}-DMPI \
			-I${MPI_INCLUDEDIR} ${CPP_PREFIX}-I${MPI_INCLUDEDIR}' \
		DEFINES='${DEFINES} -DMPI' INCLUDES='${INCLUDES}' \
		ALLBINS='${PARALLELBINS} ${EXTRABINS}' \
		INLINE=${INLINE} )

#####################################################################
#
# Auxiliary libraries
#

# LAPACK: A very old and obsolete subset of the lapack library
# which we used in the old days before the vendor libraries included lapack.
# You should avoid using this library (Ole H. Nielsen, Jan. 2007).

# The library in the destination directory
${DESTDIR}/liblapack.a: ${SRCDIR}/lapack/${ARCH}/liblapack.a
	@if [ ! -d ${DESTDIR} ]; then \
	   ${MKDIR} ${DESTDIR}; \
	fi
	cp -p ${SRCDIR}/lapack/${ARCH}/liblapack.a $@

${SRCDIR}/lapack/${ARCH}/liblapack.a: FRC
	@echo
	@echo Making $@ in directory ${SRCDIR}/lapack/${ARCH}
	@echo
	@if [ ! -d ${SRCDIR}/lapack/${ARCH} ]; then \
		${MKDIR} ${SRCDIR}/lapack/${ARCH}; \
	fi
	@(cd ${SRCDIR}/lapack/${ARCH}; \
		${MAKE} -f ../Makefile liblapack.a FC='${FC}' FFLAGS='${FFLAGS}' FNOPT='${FNOPT}' )

# BLAS library: Some special mixed-precision BLAS subroutines

# The library in the destination directory
${DESTDIR}/libmyblas.a: ${SRCDIR}/blas/${ARCH}/libmyblas.a
	@if [ ! -d ${DESTDIR} ]; then \
	   ${MKDIR} ${DESTDIR}; \
	fi
	cp -p ${SRCDIR}/blas/${ARCH}/libmyblas.a $@

${SRCDIR}/blas/${ARCH}/libmyblas.a: FRC
	@echo
	@echo Making $@ in directory ${SRCDIR}/blas/${ARCH}
	@echo
	@if [ ! -d ${SRCDIR}/blas/${ARCH} ]; then \
	   ${MKDIR} ${SRCDIR}/blas/${ARCH}; \
	fi
	@(cd ${SRCDIR}/blas/${ARCH}; \
	${MAKE} -f ../Makefile libmyblas.a FC='${FC}' FFLAGS='${FFLAGS}' )

# --- netCDF
${SRCDIR}/netcdf/${ARCH}/netcdfinterface.o : FRC
	@echo
	@echo Making $@ in directory ${SRCDIR}/netcdf/${ARCH}
	@echo
	@if [ ! -d ${SRCDIR}/netcdf/${ARCH} ]; then \
	   ${MKDIR} ${SRCDIR}/netcdf/${ARCH}; \
	fi
	@(cd ${SRCDIR}/netcdf/${ARCH} ; \
	${MAKE} -f ../Makefile netcdfsupport FC90=${FC90} FFLAGS='${FFLAGS}' CPP='${CPP_${ARCH}}' )

FRC:
#####################################################################
#
# Fundamental rules for libraries and .o files
#

# Dependency search path (GNU make special):
VPATH = ${SRCDIR}

# General rule for making .o files:
.F.o:
	${FC90} -c ${FFLAGS} ${F90FF} ${INCLUDES} $<

# Special cases for fortran90 modules, until all
# sources are converted to free format F90

run_context.o :   run_context.F ${SRCDIR}/netcdf/${ARCH}/netcdfinterface.o basicdata.o

generate_kpoints.o :   generate_kpoints.F ${SRCDIR}/netcdf/${ARCH}/netcdfinterface.o basicdata.o

read_structure_netcdf.o : read_structure_netcdf.F real_nonlocal.o  ${SRCDIR}/netcdf/${ARCH}/netcdfinterface.o \
                          matrix_utilities.o

real_nonlocal.o :   real_nonlocal.F  basicdata.o

setuop.o: setuop.F ${SRCDIR}/netcdf/${ARCH}/netcdfinterface.o basicdata.F basicdata.o

# Special cases for those modules that have inlined subroutines:
pw.o: pw.F definitions.h
	${FC90} -c ${FFLAGS} ${F90FF} ${INLINE} ${INCLUDES} $<

pwunsp.o: pwunsp.F definitions.h
	${FC90} -c ${FFLAGS} ${F90FF} ${INLINE} ${INCLUDES} $<

qrutil.o: qrutil.F definitions.h
	${FC90} -c ${FFLAGS} ${F90FF} ${INLINE} ${INCLUDES} $<

# Special cases for parallel routines, which should be compiled without
# optimization on alpha
ms.o: ms.F definitions.h
	${FC90} -c ${FFLAGS} ${F90FF} ${FNOPT} ${INLINE} ${INCLUDES} $<
par_getwf.o: par_getwf.F definitions.h
	${FC90} -c ${FFLAGS} ${F90FF} ${FNOPT} ${INLINE} ${INCLUDES} $<
par_functions.o: par_functions.F definitions.h
	${FC90} -c ${FFLAGS} ${F90FF} ${FNOPT} ${INLINE} ${INCLUDES} $<

# Special cases for parallel routines, which should be compiled without
# optimization on gfortran 4.1.1
update_netcdf_history_module.o: update_netcdf_history_module.F
	${FC90} -c ${FFLAGS} ${F90FF} ${FNOPT} ${INLINE} ${INCLUDES} $<

definitions.h: timers.h precision.h ibm.h msgpass.h

dacapo.run: ${ALLBINS} ${SRCDIR}/blas/${ARCH}/libmyblas.a \
            ${SRCDIR}/netcdf/${ARCH}/netcdfinterface.o ${SRCDIR}/netcdf/${ARCH}/MakeRestrictedSetCopy.o
	${FC} ${FFLAGS} -o dacapo.run ../netcdf/${ARCH}/netcdfinterface.o ${SRCDIR}/netcdf/${ARCH}/MakeRestrictedSetCopy.o  ${SRCDIR}/${OBJECTDIR}/basicdata.o ${ALLBINS} ${SRCDIR}/blas/${ARCH}/libmyblas.a ${LIBS} ${LIBS_${ARCH}_${MP}}

clean.f:
	rm -f *.f

# Dont remove *.i -- we have one as a source include file!
clean:
	echo cleaning: ${SRCDIR}/lapack/${ARCH}
	rm  ${SRCDIR}/lapack/${ARCH}/
	echo cleaning: ${SRCDIR}/blas/${ARCH}/
	rm  ${SRCDIR}/blas/${ARCH}/
	echo cleaning:  ${SRCDIR}/netcdf/${ARCH}/
	rm  ${SRCDIR}/netcdf/${ARCH}/
	echo cleaning:  ${SRCDIR}/{OBJECTDIR}/
	rm  ${SRCDIR}/{OBJECTDIR}/

	# rm -f dacapo *.o core out fort.*
