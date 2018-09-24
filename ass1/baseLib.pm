#!/usr/bin/env perl
package baseLib;
use warnings;
use strict;
use Exporter;
use File::Spec;

# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our database lib
use dbLib;
use textLib;


use FindBin;

use File::Copy;


our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(pop_options init_legit add_files commit_files show_log
show_file_by_ver get_track_files remove_files file_status);


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


sub remove_files {
  # option file from global file
  open  my $f, ">>", get_working_ops_file();
  # add a delete operation to operation tree
  map {print $f "D $_\n"} @_ ;
  # remove the file from working directory
  map {if (-e ".legit/__meta__/work/$_") {unlink ".legit/__meta__/work/$_"}} @_;
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
  print get_file_content_by_ver($1, $2);
}

# return a hash table of status
sub file_status  {
  # DS - The version is different from woring dir |
  # ST - The version is same as in working dir and this file is tracking |
  # NS - The change is not staged, have tracked |
  # FD - Only deleted in fs |
  # DE - Deleted in index and fs |
  # SA - Same as record |
  # AD - Indexed in working section but not tracking |
  # UC - Not tracking |
  my @files = @_;
  # hash array for status
  my %status ;
  # check all specified file status
  foreach my $file  (@files) {
    # perform a status check
    if (! -e $file) {
      # file system is deleted
      if(get_file_path_by_ver("",$file) eq ""){
        # not exist in index
        $status{$file} = "DE";
      }
      else{
        # only delected in fs
        $status{$file}= "FD";
      }
      # continue
      next;
    }

    # file path in the workign directory
    my $working_file_path = ".legit/__meta__/work/$file";
    # file path for the latest version is tracking
    my $track_path = get_file_path_by_ver("",$file);

    # the file is exist, but it might not tracked
    if ($track_path eq "") {
      if (-e $working_file_path) {
        # there is indexed
        $status{$file} = "AD";
      }
      else{
        # file is not tracked
        $status{$file} = "UC";
      }
    }
    else{
      # the file is tracked

      # read the current content in the file system file
      open my $fs, "<",$file;
      my @current_file_content = <$fs>;
      close $fs;

      if (-e $working_file_path) {
        # working dectory has a record
        open my $wk, "<",$working_file_path;
        my @working_content = <$wk>;
        close $wk;

        if (is_diff(@current_file_content, @working_content)) {
          # different from working content
          $status{$file} = "DS";
        }
        else {
          # same as index in working dir
          $status{$file} = "ST";
        }
      }
      else {
        # fetch the content in the record
        my @archived_content = get_file_content_by_ver("",$file);
        if (is_diff(@archived_content, @current_file_content)) {
          # there is a difference between tracking an the current content
          $status{$file} = "NS";
        }
        else {
          # same as tracking version
          $status{$file} = "SA";
        }
      }
    }
  }
  return %status;
}




# defualt return mark
1;
