# SDSC "chemistry" roll

## Overview

This roll bundles a collection of chemistry packages: APBS, CP2K, GROMACS,
LAMMPS,and NAMD.

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

The sdsc-roll must be installed on the build machine, since the build process
depends on make include files provided by that roll.

The roll sources assume that modulefiles provided by SDSC compiler, python, and
cmake rolls are available, but it will build without them as long as the
environment variables they provide are otherwise defined.

The build process requires the MKL, fftw, netcdf, and cuda libraries and
assumes that the modulefiles provided by the corresponding SDSC rolls are
available.  It will build without the modulefiles as long as the environment
variables they provide are otherwise defined.


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

The ROLLOPTS variable has options for "avx" and "avx2" architectures and a
"cuda" option for gpu support. gpu support is available for cp2k, gromacs,
lammps and namd.

For example, if a build for the "avx2" architecture is chosen along with the
default cuda version:

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2_ib ROLLOPTS='avx2 cuda' 2>&1 | tee build.log
```

If another version of cuda is needed, the cuda version is specified as follows:

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2_ib ROLLOPTS='avx2 cuda=cuda/8.0' 2>&1 | tee build.log
```

The lammps cuda build requires specification of the cuda capability (CC) of the
gpu hardware that the roll will be deployed on. You can specify this by including
"cudacapabilities=value[,value...]" in the ROLLOPTS variable, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2_ib ROLLOPTS='cuda cudacapabilties=37,60' 2>&1 | tee build.log
```

In this case 2 gpu enabled lammps executables, along with a lammps cpu
executable, will be compiled. A "lammps.cuda" script is available that at run
time selects the correct gpu executable.

In order to find the cuda capability of a node, run the "deviceQuery" executable
provided in the src/lammps directory on a gpu node. In order to extract the cuda
capability, run:

```shell
deviceQuery 2>&1 | grep 'CUDA Capability' |uniq |awk  '{print $6}'|sed 's/\.//
```

NOTE: Because of limitations of the system gfortran, the cp2k package in the
chemistry-roll cannot be built successfully with ROLLMPI=rocks-openmpi under
a Rocksv6 install.  For "vanilla" chemistry-roll builds, it is recommended
to build and install the SDSC mpi-roll first, then build the chemistry-roll
with ROLLMPI=openmpi_eth.


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll chemistry
% cd /export/rocks/install
% rocks create distro
```

Subsequent installs of compute and login nodes will then include the contents
of the chemistry-roll.  To avoid cluttering the cluster frontend with unused
software, the chemistry-roll is configured to install only on compute and
login nodes. To force installation on your frontend, run this command after
adding the chemistry-roll to your distro

```shell
% rocks run roll chemistry host=NAME | bash
```

where NAME is the DNS name of a compute or login node in your cluster.

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
