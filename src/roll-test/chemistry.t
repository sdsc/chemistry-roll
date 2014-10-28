#!/usr/bin/perl -w
# chemistry roll installation test.  Usage:
# chemistry.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend
my $compiler="ROLLCOMPILER";
my $mpi="ROLLMPI";

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = 'Compute';
my @packages = ('apbs', 'cp2k', 'gromacs', 'lammps', 'namd');
my $output;
my $TESTFILE = 'tmpchemistry';

# chemistry-install.xml
foreach my $package(@packages) {
  if($appliance =~ /$installedOnAppliancesPattern/) {
    ok(-d "/opt/$package", "$package installed");
  } else {
    ok(! -d "/opt/$package", "$package not installed");
  }
}

# apbs
my $packageHome = '/opt/apbs';
my $testDir = "$packageHome/examples/actin-dimer";
SKIP: {

  skip 'apbs not installed', 1 if ! -d $packageHome;
  skip 'apbs test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load apbs
cd $packageHome/examples/actin-dimer
$packageHome/bin/apbs apbs-smol-auto.in
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh`;
  ok($output =~ /Global.*energy.*\d+\.\d+.*kJ\/mol/, 'apbs sample run');

}

# cp2k
$packageHome = '/opt/cp2k';
$testDir = "$packageHome/test";
SKIP: {

  skip 'cp2k not installed', 1 if ! -d $packageHome;
  skip 'cp2k test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load cp2k
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp $testDir/* .
cp2k.popt 3H2O-ep.inp
END
close(OUT);

  $output = `/bin/bash $TESTFILE.sh 2>&1`;
  ok($output =~ /TEMPERATURE.*303.1/, 'cp2k test run');

}

# gromacs
$packageHome = '/opt/gromacs';
$testDir = "$packageHome/gmxtest/complex/acetonitrilRF";
SKIP: {

  skip 'gromacs not installed', 1 if ! -d $packageHome;
  skip 'gromacs test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load gromacs
cd $testDir
rm -f md.log
$packageHome/bin/grompp_mpi
output=`mpirun -np 1 $packageHome/bin/mdrun_mpi 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  # Recent openmpi requires special option for root user
  output=`mpirun -np 1 --allow-run-as-root $packageHome/bin/mdrun_mpi 2>&1`
fi
echo \$output
cat md.log
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh 2>&1`;
  ok($output =~ /Performance:\s+\d+(\.\d+)?/, 'gromacs sample run');

}

# lammps
$packageHome = '/opt/lammps';
$testDir = "$packageHome/examples/colloid";
SKIP: {

  skip 'lammps not installed', 1 if ! -d $packageHome;
  skip 'lammps test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load lammps
cd $packageHome/examples/colloid
output=`mpirun -np 1 $packageHome/bin/lammps < in.colloid 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  # Recent openmpi requires special option for root user
  output=`mpirun -np 1 --allow-run-as-root $packageHome/bin/lammps < in.colloid 2>&1`
fi
echo \$output
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh`;
  ok($output =~ /900 atoms/, 'lammps sample run');

}

# namd
$packageHome = '/opt/namd/2.10b1';
$testDir = '/opt/namd/2.10b1/tiny';
SKIP: {

  skip 'namd not installed', 1 if ! -d $packageHome;
  skip 'namd test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load namd
cd $testDir
$packageHome/bin/namd2 tiny.namd
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh`;
  ok($output =~ /WRITING VELOCITIES/, 'namd 2.10 sample run');
  `/bin/rm $testDir/FFTW*`;

}


# namd
$packageHome = '/opt/namd/2.9';
$testDir = '/opt/namd/2.9/tiny';
SKIP: {

  skip 'namd not installed', 1 if ! -d $packageHome;
  skip 'namd test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load namd/2.9
cd $testDir
$packageHome/bin/namd2 tiny.namd
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh`;
  ok($output =~ /WRITING VELOCITIES/, 'namd 2.9 sample run');
  `/bin/rm $testDir/FFTW*`;

}
SKIP: {

  foreach my $package(@packages) {
    skip "$package not installed", 3 if ! -d "/opt/$package";
    my ($noVersion) = $package =~ m#([^/]+)#;
    `/bin/ls /opt/modulefiles/applications/$noVersion/[0-9]* 2>&1`;
    ok($? == 0, "$package module installed");
    `/bin/ls /opt/modulefiles/applications/$noVersion/.version.[0-9]* 2>&1`;
    ok($? == 0, "$package version module installed");
    ok(-l "/opt/modulefiles/applications/$noVersion/.version",
       "$package version module link created");
  }

}

`rm -fr $TESTFILE*`;
