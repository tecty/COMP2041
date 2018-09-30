#!/usr/bin/env perl
package controller;
use warnings;
use strict;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
#  this file need to use all our basic lib except this one
use branchLib;
use fileLib;
use helperLib;
use typeLib;

our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_legit add remove commit show_log show show_status branch);

# Highest level lib

sub init_legit {
  # create a folder and some routine work

  if (! -d ".legit" and init_db() ){
    # print the promt
    print "Initialized empty legit repository in .legit\n";
  }
  else {
    # error occoured
    dd_err("legit.pl: error: .legit already exists");
  }
}

sub add {
  # pop all the actions, hence it would only contain the files
  pop_options(@_);
  add_files (@_);
}

sub commit {
  # parse the command line arguments
  my $options = pop_options(@_);
  my $commit = join " ",@_;
  if ($options =~ /a/){
    # fetch all the tracked file
    my %file_track = get_file_tracks();
    add_files(keys %file_track);
  }
  if ($options =~ /m/){
    # commit as message
    commit_files($commit);
  }
}

sub remove {
  # we can only handle the show args, we replace them
  my @args =@_;
  # edge case protection
  map {
      return 0 if ($_ =~ /^-c/ or $_=~ /^-f/);
  } @args;
  map {$_ =~ s/--force/-f/g; $_ =~ s/--cached/-c/g} @args;

  my $error_flag = 0;
  # we loved option list
  my $options = pop_options(@args);
  # if there's any not match arguments raise error
  return 0 if ($options =~ /[^\-fc]/);
  my %status = file_status(@args);


  foreach my $file (keys %status) {
    # integrety test
    if ($options !~ /f/) {
      # only the not apply -f, we don't perform the integrety test
      # check the integrety

      if ($options =~/c/) {
        if ($status{$file} !~/.[AR]./ or $status{$file} =~/ARR/){
          # prevent this from deleting
          remove_value_from_array(@args, $file);
          # and show the error message
          show_remove_error($file, $status{$file});
        }
      }
      else{
        if($status{$file} !~ /ARA/){
          show_remove_error($file, $status{$file});
          remove_value_from_array(@args, $file);
        }
      }
    }
    else {
      # show error if it's not exist in repo
      if ($status{$file} =~ /ARR/ or $status{$file} =~ /D../){
        show_remove_error($file, $status{$file});
        remove_value_from_array(@args, $file);
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

sub show_log {
  # get the logs file of current branch and print
  foreach (get_log()) {
    # print all the lines in log
    print $_;
  }
}

sub show {
  if(pop_options(@_) and @_ != 1){
    # parse command line error
    return 0;
  }
  my ($file_id) = @_;
  if ($file_id =~ /([^:]*):(.*)/){
    print get_file_content_by_commit($2,$1);
  }
  else {
    dd_err("legit.pl: error: invalid object a");
  }
}

sub show_status {
  # use $cur_ver to let the deleted flag work, if use "", that make op to ""
  # "" has different meaning

  my %status = get_curr_status();
  map {
    $status{$_}=~s/ADD/file changed, different changes staged for commit/;
    $status{$_}=~s/AAD/file changed, changes staged for commit/;
    $status{$_}=~s/ARD/file changed, changes not staged for commit/;
    $status{$_}=~s/R.A/file deleted/;
    $status{$_}=~s/(R.R|DR[RA])/deleted/;
    $status{$_}=~s/A.A/same as repo/;
    $status{$_}=~s/AAR/added to index/;
    $status{$_}=~s/(ARR|DRD)/untracked/;
  } keys %status;

  # show the replaced message
  foreach my $key (sort keys %status) {
    print "$key - $status{$key}\n";
  }
}

sub branch{
  if (@_ == 0){
    return ;
  }
}
1;
