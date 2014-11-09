# SDSC "chemistry" roll

## Overview

This roll bundles a collection of chemistry packages: APBS, CP2K, GROMACS,
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

To build the chemistry-roll, execute this on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make 2>&1 | tee build.log
```

A successful build will create the file `chemistry-*.disk1.iso`.  If you built the
roll on a Rocks frontend, proceed to the installation step. If you built the
roll on a Rocks development appliance, you need to copy the roll to your Rocks
frontend before continuing with installation.

This roll source supports building with different compilers and for different
MPI flavors.  The `ROLLCOMPILER` and `ROLLMPI` make variables can be used to
specify the names of compiler and MPI modulefiles to use for building the
software, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2_ib 2>&1 | tee build.log
```

The build process recognizes "gnu", "intel" or "pgi" as the value for the
`ROLLCOMPILER` variable; any MPI modulefile name may be used as the value of
the `ROLLMPI` variable.  The default values are "gnu" and "rocks-openmpi".

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

In addition to the software itself, the roll installs package environment
module files in:

```shell
/opt/modulefiles/applications/{apbs,cp2k,gromacs,lammps,namd}
```


## Testing

The chemistry-roll includes a test script which can be run to verify proper
installation of the roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/chemistry.t 
```
