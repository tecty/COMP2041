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
show_file_by_ver get_track_files remove_files file_status delete_value_in_array);


sub delete_value_in_array (\@$) {
  my ($arr_ref , $value) = @_;
  for (my $index = 0; $index <= $#$arr_ref; $index++) {
    if ($$arr_ref[$index] eq $value) {
      splice @$arr_ref, $index, 1;
    }
  }
}

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
  #  F I R (File system, Indexed, Repository)
  #        Appear
  #  -     Different
  #        Remove
  my @files = @_;
  # hash array for status
  my %status ;
  # check all specified file status
  foreach my $file  (uniq sort @files) {
    # print ("imhere",$file );
    if (-e $file ) {
      $status{$file} .= "A";
    }
    else {
      $status{$file} .= "R";
      # only need to check wether it's Appear in the $working_dir or repository
      (-e ".legit/__meta__/work/$file") ?
        $status{$file} .= "A" :$status{$file} .= "R";

      # whether it's track in repository
      get_file_path_by_ver("",$file) ne ""?
        $status{$file} .= "A" :$status{$file} .= "R";

      # short circute remain checks
      next;
    }

    # the file exist, we need to perform difference check

    # open the file and read the content inside
    open my $f, "<", $file;
    my @fs_content =  <$f>;
    close $f;


    # check the content in working directory
    if (-e ".legit/__meta__/work/$file") {
      open my $work, "<", ".legit/__meta__/work/$file";
      my @work_content = <$work>;
      close $work;
      if(is_diff(@work_content,@fs_content)){
        $status{$file} .= "D";
      }
      else{
        $status{$file} .= "A";
      }
    }
    else{
      $status{$file} .= "R";
    }

    # checking the content in repository
    if (get_file_path_by_ver("", $file) ne "") {
      my @rep_content = get_file_content_by_ver("",$file);
      if (is_diff(@rep_content, @fs_content)) {
        $status{$file} .= "D";
      }
      else{
        $status{$file} .= "A";
      }
    }
    else{
      $status{$file} .= "R";
    }
  }
  return %status;
}




# defualt return mark
1;
