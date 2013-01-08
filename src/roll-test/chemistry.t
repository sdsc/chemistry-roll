#!/usr/bin/perl -w
# chemistry roll installation test.  Usage:
# chemistry.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = 'Compute';
my @packages = ('apbs', 'cp2k', 'gromacs', 'lammps', 'namd');
my $output;
my $TESTFILE = 'tmpchemistry';

# chemistry_doc.xml
if ($appliance eq 'Frontend') {
  ok(-d '/var/www/html/roll-documentation/chemistry', 'doc installed');
} else {
  ok(! -d '/var/www/html/roll-documentation/chemistry', 'doc not installed');
}

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
if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
  module load ROLLCOMPILER apbs
fi
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
if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
  module load ROLLCOMPILER ROLLMPI_ROLLNETWORK cp2k
fi
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
if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
  module load ROLLCOMPILER ROLLMPI_ROLLNETWORK gromacs
fi
cd $testDir
$packageHome/bin/grompp 
mpirun -np 1  $packageHome/bin/mdrun
cat md.log
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh 2>&1`;
  ok($output =~ /Total Dipole/, 'gromacs sample run');

}

# lammps
$packageHome = '/opt/lammps';
$testDir = "$packageHome/examples/colloid";
SKIP: {

  skip 'lammps not installed', 1 if ! -d $packageHome;
  skip 'lammps test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
  module load ROLLCOMPILER ROLLMPI_ROLLNETWORK lammps
fi
cd $packageHome/examples/colloid
mpirun -np 1  $packageHome/bin/lammps < in.colloid
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh`;
  ok($output =~ /900 atoms/, 'lammps sample run');

}

# namd
$packageHome = '/opt/namd';
$testDir = '/opt/namd/tiny';
SKIP: {

  skip 'namd not installed', 1 if ! -d $packageHome;
  skip 'namd test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
  module load ROLLCOMPILER ROLLMPI_ROLLNETWORK
fi
cd $testDir
$packageHome/bin/namd2 tiny.namd
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh`;
  ok($output =~ /WRITING VELOCITIES/, 'namd 2.9 sample run');
  `/bin/rm $testDir/FFTW*`;

}

SKIP: {

  skip 'chemistry not installed', 1
    if $appliance !~ /$installedOnAppliancesPattern/;
  skip 'modules not installed', 1 if ! -f '/etc/profile.d/modules.sh';
  foreach my $package(@packages) {
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