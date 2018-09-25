#!/usr/bin/env perl
use warnings;
use strict;


use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our base lib
use baseLib;
use dbLib;

#
# Required the actions
#

sub commit {
  my @list_arg=@_;

  # pop all the options
  my $options = pop_options(@list_arg);

  if ($options =~ /m/ ) {

  }
}

sub add {
  # pop all the actions, hence it would only contain the files
  pop_options(@_);
  add_files @_;
}
sub remove {
  # we can only handle the show args, we replace them
  my @args =@_;
  map {$_ =~ s/--force/-f/g; $_ =~ s/--cached/-c/g} @args;


  # we loved option list
  my $options = pop_options(@args);
  # integrety test
  if ($options !~ /f/) {
    # only the not apply -f, we don't perform the integrety test
    # check the integrety
    my %status = file_status(@args);
    # if ($_ ne "ST" and $_ ne "SA" and $_ ne "FD" and $_ ne "UC") {

    my $error_flag = 0;

    foreach my $file (keys %status) {
      my $this_status = $status{$file};
      if ($this_status =~/ADD/) {
        print STDERR "$0: error: '$file' in index is different to both working file and repository\n";
        $error_flag = 1;
      }
      elsif ($this_status =~/AA[DR]/) {
        print STDERR "$0: error: '$file' has changes staged in the index\n";
        $error_flag = 1;
      }
      elsif ($this_status =~/A[AR]D/) {
        print STDERR "$0: error: '$file' in repository is different to working file\n";
        $error_flag = 1;
      }
      elsif ($this_status =~/ARR/) {
        print STDERR "$0: error: '$file' is not in the legit repository\n";
        $error_flag = 1;
      }

    }

    if ($error_flag == 1){
      # couldn't perform the delete, exit incorrectly
      exit 1;
    }
  }
  if ($options !~ /c/ ) {
    # remove the current directory's file
    unlink @args;
  }
  # remove the archived file by adding a operation in record
  remove_files(@args);
}

sub show_status {
  my @indexed_files = get_track_files();
  push (@indexed_files,glob("*"));
  @indexed_files = uniq(sort @indexed_files);
  my %status = file_status(@indexed_files);
  map {
    $status{$_}=~s/ADD/file changed, different changes staged for commit/;
    $status{$_}=~s/AAD/file changed, changes staged for commit/;
    $status{$_}=~s/ARD/file changed, changes not staged for commit/;
    $status{$_}=~s/R.A/file deleted/;
    $status{$_}=~s/R.R/deleted/;
    $status{$_}=~s/A.A/same as repo/;
    $status{$_}=~s/AAR/added to index/;
    $status{$_}=~s/ARR/untracked/;
  } keys %status;


  # show the replaced message
  foreach my $key (sort keys %status) {
    print "$key - $status{$key}\n";
  }

}



sub main {
  # a big switch to dispatch to inter function
  # dispatch by command line args


  if ($#ARGV + 1 == 0) {
    # print the error message
    print "Usage: $0 [commands]\n";
    exit 1;
  }

  # shift out the first word as sub command
  my $command = shift @ARGV;

  if ($command eq "init") {
    # call the init function
    init_legit(@ARGV);
  }
  elsif($command eq "add"){
    # add the files to working directory
    add(@ARGV);
  }
  elsif($command eq "commit"){
    # parse the command line arguments
    my $options = pop_options(@ARGV);
    my $commit = join " ",@ARGV;
    if ($options =~ /a/){
      # fetch all the tracked file
      my @files = get_track_files();
      add_files(@files);
    }
    if ($options =~ /m/){
      # commit as message
      commit_files($commit);
    }
  }
  elsif($command eq "log"){
    show_log();
  }
  elsif($command eq "show"){
    show_file_by_ver(@ARGV);
  }
  elsif($command eq "rm"){
    remove(@ARGV);
  }
  elsif($command eq "status"){
    show_status();
  }
}

main();
