#!/usr/bin/perl -w
# chemistry roll installation test.  Usage:
# chemistry.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '^(?!Frontend).';
my @packages = ('abinit','apbs', 'cp2k', 'gromacs', 'lammps', 'namd');
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


# abinit
my $packageHome = '/opt/abinit';
my $testDir = "$packageHome/share/abinit-test/paral/Input";
SKIP: {

  skip 'abinit not installed', 1 if ! -d $packageHome;
  skip 'abinit test not installed', 1 if ! -d $testDir;
 `mkdir $TESTFILE.dir`;
 open(OUT, ">$TESTFILE.sh");
 print OUT <<END;
module load abinit
cd $TESTFILE.dir
cp $packageHome/share/abinit-test/paral/Input/t01.in .
cat <<ENDIT > t01.files
t01.in
t01.out
t01_Xi
t01_Xo
t01_Xx
$packageHome/share/abinit-test/Psps_for_tests/14si.psp
ENDIT
output=`mpirun -np 4 $packageHome/bin/abinit <t01.files 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -np 4 $packageHome/bin/abinit <t01.files 2>&1`
fi
echo \$output
END
close(OUT);
  $output = `bash $TESTFILE.sh 2>&1`;
  $output=`cat $TESTFILE.dir/t01.out 2>&1`;
  ok($output =~ /etotal     -8.593873/, 'abinit sample run');
  `rm -rf $TESTFILE*`;
}


# apbs
$packageHome = '/opt/apbs';
$testDir = "$packageHome/examples/actin-dimer";
SKIP: {

  skip 'apbs not installed', 1 if ! -d $packageHome;
  skip 'apbs test not installed', 1 if ! -d $testDir;
  `mkdir $TESTFILE.dir`;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load apbs
cd $TESTFILE.dir
cp -r $packageHome/examples/actin-dimer/* .
$packageHome/bin/apbs apbs-smol-auto.in
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh 2>&1`;
  ok($output =~ /Global.*energy.*\d+\.\d+.*kJ\/mol/, 'apbs sample run');
  `rm -rf $TESTFILE*`;
}

# cp2k
$packageHome = '/opt/cp2k';
$testDir = "$packageHome/test";
SKIP: {

  skip 'cp2k not installed', 1 if ! -d $packageHome;
  skip 'cp2k test not installed', 1 if ! -d $testDir;
  `mkdir $TESTFILE.dir`;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load cp2k
cd $TESTFILE.dir
cp $testDir/* .
output=`mpirun -np 8 cp2k.popt MC_QS.inp 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -np 8 cp2k.popt MC_QS.inp 2>&1`
fi
echo \$output
END
close(OUT);

  $output = `/bin/bash $TESTFILE.sh 2>&1`;
  ok($output =~ /ENERGY.*-51.3432165/, 'cp2k test run');
  `rm -rf $TESTFILE*`;
}

# gromacs
$packageHome = '/opt/gromacs';
$testDir = "$packageHome/gmxtest/complex/acetonitrilRF";
SKIP: {

  skip 'gromacs not installed', 2 if ! -d $packageHome;
  skip 'gromacs test not installed', 2 if ! -d $testDir;
  `mkdir $TESTFILE.dir`;
  `cp -r $testDir/* $TESTFILE.dir`;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load gromacs
export OMP_NUM_THREADS=1
cd $TESTFILE.dir
rm -f md.log
$packageHome/bin/gmx_mpi grompp
output=`mpirun -np 1 $packageHome/bin/gmx_mpi mdrun \$1 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  # Recent openmpi requires special option for root user
  output=`mpirun -np 1 --allow-run-as-root $packageHome/bin/gmx_mpi mdrun \$1 2>&1`
fi
echo \$output
cat md.log
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh 2>&1`;
  like($output, qr#Performance:\s+\d+(\.\d+)?#, 'gromacs sample run');
  SKIP: {
    skip 'CUDA_VISIBLE_DEVICES undef', 1
      if ! defined($ENV{'CUDA_VISIBLE_DEVICES'});
    my $gpus = $ENV{'CUDA_VISIBLE_DEVICES'};
    $gpus =~ s/,//g;
    $output = `/bin/bash $TESTFILE.sh "--gpu_id $gpus" 2>&1`;
    print $output;
    like($output, qr#Performance:\s+\d+(\.\d+)?#, 'gromacs cuda sample run');
  }
  `rm -rf  $TESTFILE*`;
}

# lammps
$packageHome = '/opt/lammps';
$testDir = "$packageHome/examples/colloid";
SKIP: {

  skip 'lammps not installed', 1 if ! -d $packageHome;
  skip 'lammps test not installed', 1 if ! -d $testDir;
  `mkdir $TESTFILE.dir`;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
module load lammps
cd $TESTFILE.dir
cp $packageHome/examples/colloid/* .
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
  `rm -rf $TESTFILE*`;
}

# namd
$packageHome = '/opt/namd';
SKIP: {

  skip 'namd not installed', 1 if ! -d $packageHome;

  $output = `ls $packageHome`;
  chomp($output);

  foreach my $version(split(/\s+/, $output)) {
    skip "namd $version test not installed", 2
      if ! -d "$packageHome/$version/tiny";
    `mkdir $TESTFILE.dir`;
    `cp $packageHome/$version/tiny/* $TESTFILE.dir/`;
    $output = `module load namd/$version;cd $TESTFILE.dir;namd2 tiny.namd 2>&1`;
    like($output, qr#WRITING VELOCITIES#, "namd $version sample run");
    SKIP: {
      skip 'namd $version cuda version not installed', 1 if ! -f "$packageHome/$version/bin/namd2.cuda";
      skip 'CUDA_VISIBLE_DEVICES undef', 1
        if ! defined($ENV{'CUDA_VISIBLE_DEVICES'});
      $output = `module load namd/$version;cd $TESTFILE.dir;namd2.cuda +devices $ENV{'CUDA_VISIBLE_DEVICES'} tiny.namd 2>&1`;
      like($output, qr#WRITING VELOCITIES#, "namd.cuda $version sample run");
    }
    `rm -rf $TESTFILE*`;
  }

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
