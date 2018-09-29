#!/usr/bin/env perl
use File::Copy;
use Cwd qw(cwd);
use File::Temp qw/tempdir/;


$script_path = cwd;

@tests = glob("myTest/*.sh");

$index = 0 ;
map {
  $test_name = sprintf ("test%02d.sh", $index);
  copy($_,$test_name);
  $index ++;
}@tests;

$std_script = "/home/cs2041/bin/legit";
foreach my $testfile (@tests) {
  open $testfile, "<", "$script_path/$testfile";
  @test_content = <$testfile>;
  close $testfile;
  map {$_ =~ s?\./legit.pl?$std_script?g} @test_content;

  # the testfile addr
  $test_name =  $testfile ;
  $test_name =~ s?myTest/??g;
  $test_name =~ s?\.sh??g;
  $testfile = "$testsDir/$test_name.sh";

  # write the test content
  open my $f, ">", "$testfile";
  print $f @test_content;
  close $f;

  # excute the generated script and dump it to our correct file
  open my $f, ">", "$script_path/myTest/$test_name.correct";
  print `$testfile`;
  close $f;
}
