# SDSC "chemistry" roll

## Overview

This roll bundles a collection of chemistry packages: ABPS, CP2K, GROMACS,
LAMMPS, and NAMD.

For more information about the various packages included in the chemistry roll
please visit their official web pages:

- <a href="http://www.poissonboltzmann.org/apbs/" target="_blank">APBS</a> is a software package for modeling biomolecular solvation through solution of the Poisson-Boltzmann equation.
- <a href="http://www.cp2k.org" target="_blank">CP2K</a> is a program to perform atomistic and molecular simulations of solid state, liquid, molecular, and biological systems.
- <a href="http://www.gromacs.org" target="_blank">GROMACS</a> is a versatile package to perform molecular dynamics, i.e. simulate the Newtonian equations of motion for systems with hundreds to millions of particles.
- <a href="http://lammps.sandia.gov" target="_blank">LAMMPS</a> is a classical molecular dynamics code, and an acronym for Large-scale Atomic/Molecular Massively Parallel Simulator.
- <a href="http://www.ks.uiuc.edu/Research/namd/" target="_blank">NAMD</a> is a parallel molecular dynamics code designed for high-performance simulation of large biomolecular systems.


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate chemistry source file(s) using a machine that does have
Internet access and copy them into the `src/<package>` directories on your Rocks
development machine.


## Dependencies

Intel MKL libraries.  If you're building with the Intel compiler or there is
an mkl modulefile present (the mkl-roll provides this), then the build process
will pick these up automatically.  Otherwise, you'll need to set the MKL_ROOT
environment variable to the library location.

FFTW libraries.  If there is
an fftw modulefile present (the fftw-roll provides this), then the build process
will pick these up automatically.  Otherwise, you'll need to set the FFTWHOME
environment variable to the library location.

CUDA libraries.  If there is
a cuda modulefile present, then the build process
will pick these up automatically.  Otherwise, you'll need to set the CUDAHOME
environment variable to the library location.

## Building

To build the chemistry-roll, execute these instructions on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make default 2>&1 | tee build.log
% grep "RPM build error" build.log
```

If nothing is returned from the grep command then the roll should have been
created as... `chemistry-*.iso`. If you built the roll on a Rocks frontend then
proceed to the installation step. If you built the roll on a Rocks development
appliance you need to copy the roll to your Rocks frontend before continuing
with installation.

This roll source supports building with different compilers and for different
network fabrics and mpi flavors.  By default, it builds using the gnu compilers
for openmpi ethernet.  To build for a different configuration, use the
`ROLLCOMPILER`, `ROLLMPI` and `ROLLNETWORK` make variables, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mpich2 ROLLNETWORK=mx 
```

The build process currently supports one of the values "intel", "pgi",
and "gnu" for the `ROLLCOMPILER` variable, defaulting to "gnu".  It supports
`ROLLMPI` values "openmpi" and "mvapich2", defaulting to "openmpi".
It uses any `ROLLNETWORK` variable value(s) to load appropriate mpi modules,
assuming that there are modules named `$(ROLLMPI)_$(ROLLNETWORK)` available
(e.g., `openmpi_mx`, `mvapich2_ib`, etc.).
If possible,
the build process uses the ROLLCOMPILER value to load an environment module,
and it supports using the ROLLCOMPILER value to specify a particular compiler
version, e.g.,

```shell
% make ROLLCOMPILER=gnu/4.8.1
```

If the `ROLLCOMPILER`, `ROLLNETWORK` and/or `ROLLMPI` variables are specified,
their values are incorporated into the names of the produced rpms, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2 ROLLNETWORK=ib
```
produces an rpm with a name that begins "`chemistry_intel_mvapich2_ib`".

For gnu compilers, the roll also supports a `ROLLOPTS` make variable value of
'avx', indicating that the target architecture supports AVX instructions.


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll chemistry
% cd /export/rocks/install
% rocks create distro
% rocks run roll chemistry | bash
```

```shell
/opt/modulefiles/applications/namd
/opt/modulefiles/applications/gromacs
/opt/modulefiles/applications/lammps
/opt/modulefiles/applications/cp2k
/opt/modulefiles/applications/apbs
```


## Testing

The chemistry-roll includes a test script which can be run to verify proper
installation of the chemistry-roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/chemistry.t 
