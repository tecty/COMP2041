#!/usr/bin/env perl
use Cwd qw(cwd);
use File::Temp qw/tempdir/;


$script_path = cwd;

# fetch the tests we want to test
@tests = glob ("tests/*.sh");
$testsDir = tempdir();

# count the failed test
$fail_count = 0;

foreach my $testfile (@tests) {
  print "------\nTesting $testfile:\n";

  open $testfile, "<", "$script_path/$testfile";
  @test_content = <$testfile>;
  close $testfile;
  map {$_ =~ s?\./?$script_path/?g} @test_content;
  # fetch the correct path of the correct script
  $correct_file = $testfile;
  $correct_file =~ s/.sh$/.correct/g;
  $correct_file = "$script_path/$correct_file";

  # the testfile addr
  $testfile = "$testsDir/$testfile";
  $testfile =~ s?tests/??g;

  # write the test content
  open my $f, ">", "$testfile";
  print $f @test_content;
  close $f;
  #
  # open my $f, "<", $testfile;
  # print <$f>;
  # close $f;

  # get a tmp dir
  $clean = tempdir();
  chdir $clean;


  # print it to the file
  @test_output = `bash $testfile 2>&1`;

  # print @test_output;
  # change it to store the tmp output
  $testfile =~ s/.sh$/.tmp/g;
  open $out ,">", $testfile;
  print $out @test_output;
  close $out;

  # compare both file
  @diff_out = `diff $testfile $correct_file`;
  if (@diff_out) {
    $fail_count ++;
    print @diff_out,"\n";
  }

}

print "Test Result:\nFailed: $fail_count/", $#tests +1, "\n";
