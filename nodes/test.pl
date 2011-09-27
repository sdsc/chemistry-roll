#!/usr/bin/perl
use Test::More tests => 1;
$packageHome = '/opt/gromacs';
$testDir = "$packageHome/gmxtest/complex/acetonitrilRF";
SKIP: {
  skip 'gromacs not installed', 1 if ! -d $packageHome;
  skip 'gromacs test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
. /etc/profile.d/modules.sh
module load intel openmpi_mx gromacs
cd $testDir
hostname > nodes
mpirun -np 1 -machinefile nodes $packageHome/bin/grompp 
cat md.log
/bin/rm -f nodes
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh`;
  ok($output =~ /Total Dipole/, 'gromacs sample run');
}
