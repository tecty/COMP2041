#!/usr/bin/env perl
package baseLib;
use warnings;
use strict;
use Exporter;


use FindBin;
use File::Spec;
use File::Copy;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our database lib
use dbLib;


our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(pop_options init_legit add_files commit_files show_log
show_file_by_ver);


sub pop_options(\@) {
  # pop all the option in the array
  my ($arr_ref)= @_;

  # grep all opotions
  my @options = grep {$_ =~ /^-(.*)/ } @$arr_ref;

  # pop all the dash in the array
  @options = grep {$_ =~ s/^-(.*)/$1/g } @options;

  # remove all the options in the array
  @$arr_ref = grep { $_ !~ /^-(.*)/ } @$arr_ref;

  # return all the options as a single string
  return join("", @options);;
}

sub init_legit {
  # create a folder and some routine work

  if (init_db ){
    # print the promt
    print "Initialized empty legit repository in .legit\n";
  }
  else {
    # error occoured
    print STDERR "$0: error: .legit already exists\n";
  }
}

sub add_files (\@) {
  my ($files) = @_;

  # copy all files to working directory
  map { copy($_, get_working_directory())} @$files;

  # track the operations to
  open  my $f, ">>", get_working_ops_file();
  map { print $f "A $_\n"} @$files;
  close $f;
}

sub commit_files{
  my ($commit) = @_;
  add_commit($commit);
  print "Committed as commit ",get_cur_ver(),"\n";
  # print ;
}

sub show_log {
  # get the logs file of current branch and print
  open my $log,"<",get_branch_path("","__meta__/commits");
  print reverse <$log>;
}



sub show_file_by_ver{
  my ($arg) = @_;
  $arg =~ /([0-9]*):(.*)/;
  # get the version and file by regrex result
  my $path = get_latest_file_path($1, $2);
  if ($path ne ""){
    # cat the file
    open my $f, "<", $path;
    print <$f>;
    close $f;
  }
  else{
    print "$2 desn't exist \n"
  }
}

# defualt return mark
1;
