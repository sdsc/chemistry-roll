# SDSC "chemistry" roll

## Overview

This roll bundles a collection of chemistry packages: ABPS, CP2K, GROMACS,
LAMMPS, and NAMD. 

For more information about the various packages included in the chemistry roll please visit their official web pages:

- <a href="http://www.poissonboltzmann.org/apbs/" target="_blank">APBS</a> is a software package for modeling biomolecular solvation through solution of the Poisson-Boltzmann equation.
- <a href="http://www.cp2k.org" target="_blank">CP2K</a> is a program to perform atomistic and molecular simulations of solid state, liquid, molecular, and biological systems.
- <a href="http://www.gromacs.org" target="_blank">GROMACS</a> is a versatile package to perform molecular dynamics, i.e. simulate the Newtonian equations of motion for systems with hundreds to millions of particles.
- <a href="http://lammps.sandia.gov" target="_blank">LAMMPS</a> is a classical molecular dynamics code, and an acronym for Large-scale Atomic/Molecular Massively Parallel Simulator.
- <a href="http://www.ks.uiuc.edu/Research/namd/" target="_blank">NAMD</a> is a parallel molecular dynamics code designed for high-performance simulation of large biomolecular systems.


## Requirements

To build/install this roll you must have root access to a Rocks development machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must download the appropriate R source file(s) using a machine that does have Internet access and copy them into the `src/<package>` directories on your Rocks development machine.


## Dependencies

Unknown at this time.


## Building

To build the chemistry-roll, execute these instructions on a Rocks development machine (e.g., a frontend or development appliance):

```shell
% make default 2>&1 | tee build.log
% grep "RPM build error" build.log
```

If nothing is returned from the grep command then the roll should have been created as... `chemistry-*.iso`. If you built the roll on a Rocks frontend then proceed to the installation step. If you built the roll on a Rocks development appliance you need to copy the roll to your Rocks frontend before continuing with installation.

This roll source supports building with different compilers and for different
network fabrics and mpi flavors.  By default, it builds using the gnu compilers
for openmpi ethernet.  To build for a different configuration, use the
`ROLLCOMPILER`, `ROLLMPI` and `ROLLNETWORK` make variables, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mpich2 ROLLNETWORK=mx 
```

The build process currently supports one or more of the values "intel", "pgi",
and "gnu" for the `ROLLCOMPILER` variable, defaulting to "gnu".  It supports
`ROLLMPI` values "openmpi", "mpich2", and "mvapich2", defaulting to "openmpi".
It uses any `ROLLNETWORK` variable value(s) to load appropriate mpi modules,
assuming that there are modules named `$(ROLLMPI)_$(ROLLNETWORK)` available (e.g., `openmpi_ib`, `mpich2_mx`, etc.).

If the `ROLLCOMPILER`, `ROLLNETWORK` and/or `ROLLMPI` variables are specified, their values are incorporated into the names of the produced roll and rpms, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2 ROLLNETWORK=ib
```
produces a roll with a name that begins "`chemistry_intel_mvapich2_ib`"; it
contains and installs similarly-named rpms.

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

Note that the optimization techniques used by ATLAS dictate only installing
the package on systems with the same architecture and configuration as the
build machine.

In addition to the software itself, the roll installs ATLAS environment module
files in:

```shell
/opt/modulefiles/applications/.(compiler)/chemistry.
```


## Testing

The chemistry-roll includes a test script which can be run to verify proper installation of the chemistry-roll documentation, binaries and module files. To run the test scripts execute the following command(s):

```shell
% /root/rolltests/chemistry.t 
ok 1 - chemistry is installed
ok 2 - chemistry test run
ok 3 - chemistry module installed
ok 4 - chemistry version module installed
ok 5 - chemistry version module link created
1..5
```
