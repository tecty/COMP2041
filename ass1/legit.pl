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

sub add {
  # pop all the actions, hence it would only contain the files
  pop_options(@_);
  add_files @_;
}

our %status;
sub show_remove_error{
  my ($file) = @_;
  my $this_status = $status{$file};
  if ($this_status =~/ADD/) {
    print STDERR "legit.pl: error: '$file' in index is different to both working file and repository\n";
  }
  elsif ($this_status =~/AA./) {
    print STDERR "legit.pl: error: '$file' has changes staged in the index\n";
  }
  elsif ($this_status =~/A[AR]D/) {
    print STDERR "legit.pl: error: '$file' in repository is different to working file\n";
  }
  elsif ($this_status =~/[DA]R[RD]/) {
    print STDERR "legit.pl: error: '$file' is not in the legit repository\n";
  }
}


sub remove {
  # we can only handle the show args, we replace them
  my @args =@_;
  map {$_ =~ s/--force/-f/g; $_ =~ s/--cached/-c/g} @args;
  my $error_flag = 0;


  # we loved option list
  my $options = pop_options(@args);

  %status = file_status(@args);


  foreach my $file (keys %status) {
    # integrety test
    if ($options !~ /f/) {
      # only the not apply -f, we don't perform the integrety test
      # check the integrety

        if ($options =~/c/) {
          if ($status{$file} !~/.[AR]./ or $status{$file} =~/ARR/){
            # prevent this from deleting
            delete_value_in_array(@args, $file);
            # and show the error message
            show_remove_error($file);
          }
        }
        else{
          if($status{$file} !~ /ARA/){
            show_remove_error($file);
            delete_value_in_array(@args, $file);
          }
        }
    }
    else {
      # show error if it's not exist in repo
      if ($status{$file} =~ /ARR/ or $status{$file} =~ /D../){
        show_remove_error($file);
        delete_value_in_array(@args, $file);
      }
    }
  }
  if ($options !~ /c/ and $error_flag != 1) {
    # remove the current directory's file
    unlink @args;
  }
  # Alway remove the cached files
  # remove the archived file by adding a operation in record
  remove_files(@args);
}

sub show_status {
  # use $cur_ver to let the deleted flag work, if use "", that make op to ""
  # "" has different meaning
  my @indexed_files = get_track_files(get_cur_ver());
  push (@indexed_files,glob("*"));
  @indexed_files = uniq(sort @indexed_files);
  my %status = file_status(@indexed_files);
  map {
    $status{$_}=~s/ADD/file changed, different changes staged for commit/;
    $status{$_}=~s/AAD/file changed, changes staged for commit/;
    $status{$_}=~s/ARD/file changed, changes not staged for commit/;
    $status{$_}=~s/R.A/file deleted/;
    $status{$_}=~s/(R.R|DRR)/deleted/;
    $status{$_}=~s/A.A/same as repo/;
    $status{$_}=~s/AAR/added to index/;
    $status{$_}=~s/(ARR|DRD)/untracked/;
  } keys %status;

  # show the replaced message
  foreach my $key (sort keys %status) {
    print "$key - $status{$key}\n";
  }
}

sub branch {
  my @args = @_;
  # we loved option list
  my $options = pop_options(@args);

  if ($options !~ /d/) {
    # creating branch
    create_branch($args[0],get_cur_branch_id());
  }
  else{
    # deleting branch
    remove_branch($args[0]);
  }
}


sub checkout {
  my @args = @_;
  # we loved option list
  my $options = pop_options(@args);

  set_cur_branch($args[0]);
  print "Switched to branch '$args[0]'\n";
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
    # break the rest of match
    exit 0;
  }
  if (! -d ".legit"){
    # not exist error abort all the actions
    print STDERR "legit.pl: error: no .legit directory containing legit repository exists\n";
    exit 1;
  }
  if($command eq "add"){
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
  elsif($command eq "branch"){
    branch(@ARGV);
  }
  elsif($command eq "checkout"){
    checkout(@ARGV);
  }
  elsif($command eq "merge"){

  }
  else{
    print STDERR "legit.pl: error: not valid legit command\n";
    exit 1;
  }
}

main();
