#!/usr/bin/env perl
package dbLib;
use warnings;
use strict;
use Exporter;

# ues path to create a path more easily
use File::Path qw(make_path);
use File::Copy;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_db get_branch_path set_cur_branch get_cur_branch
get_working_directory add_commit get_cur_ver get_file_path_by_ver
get_working_ops_file uniq get_track_files get_file_content_by_ver);

sub get_working_directory {
  return ".legit/__meta__/work"
}

sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}

sub touch {
  # a quick version of map
  map {open my $f,">>",$_; close $f } @_;
}

sub get_working_ops_file {
  # if there's no exist, then touch the file
  my $op_file = ".legit/__meta__/ops";
  if (! -e $op_file){
    touch($op_file);
  }
  return $op_file;
}

sub get_value_from_file {
  my ($file) = @_;
  # create a file to record the current branch
  open my $f, "<", $file;
  my @lines = <$f>;
  close $f;
  # return the first line, since it only has one line
  return $lines[0];
}

sub set_value_to_file {
  my ($file, $value) = @_;
  # create a file to record the current branch
  open F, ">", $file;
  print F $value;
  close F;
}



sub create_branch {
  my ($branch) = @_;

  # path to meta data for master branch
  my $path = get_branch_path($branch, "__meta__");

  # make a directory for this branch
  if (make_path($path)){
    # create an empty file for commits and operations
    touch("$path/commits","$path/ops","$path/currentVer");

    # successfully
    return 1;
  }
  # error occoured
  return 0;
}

sub set_cur_branch {
  return set_value_to_file(".legit/__meta__/cur_branch",@_);
}
sub get_cur_branch {
  return get_value_from_file(".legit/__meta__/cur_branch");
}

sub get_branch_path {
  # this function as a wrapper to generate the path to different
  # branch name
  my ($branch,$sub) = @_;
  # branch would be default to current branch
  $branch = (defined $branch and $branch ne "")? $branch : get_cur_branch();
  # mute the error by setting the default value
  $sub = (defined $sub and $branch ne "")? $sub: "";
  # generate the path
  return ".legit/$branch/$sub";
}


sub init_db {
  # create legit file sturecture
  # create a default branch name master
  if (
      make_path(".legit/__meta__/work") and
      create_branch("master") and
      set_cur_branch("master")
    ) {
    # init success fully

    return 1;
  }
  # else: some error occoured

  return 0;
}


#
# Commit support
#
sub get_cur_ver {
  # get the current branch's meta
  my $meta_path = get_branch_path(get_cur_branch(),"__meta__");
  my $cur_ver = get_value_from_file("$meta_path/currentVer");
  return defined $cur_ver? $cur_ver: -1;
}

sub add_commit {
  my ($commit) = @_;

  # ----
  # get the current branch's meta
  my $meta_path = get_branch_path("","__meta__");

  # fetch the current version
  my $cur_ver = get_cur_ver();

  # add up the current ver
  $cur_ver ++;

  # add the commit to record
  open my $commitFile,">>", "$meta_path/commits";
  print $commitFile  "$cur_ver $commit\n";

  # save the current vertion to file
  set_value_to_file("$meta_path/currentVer", $cur_ver);

  # ----
  # copy the file to the this version's directory to archive them

  #create a dir for current version
  my $archive_dir = get_branch_path("",$cur_ver);
  # get the global directory
  my $working_dir = get_working_directory();
  # touch the archive folder
  make_path($archive_dir);
  # move all the working file to archive folder
  map {move($_,$archive_dir)} glob("$working_dir/*");

  # ----
  # add the track operations
  copy_op_file();
}

sub copy_op_file {
  my $cur_ver = get_cur_ver();
  open my $f,"<", get_working_ops_file();
  # print <$f>;
  my @lines = uniq(<$f>);
  close $f;
  # delete the old operations file
  unlink get_working_ops_file();

  # generate this version's option track
  open my $opt, ">", get_branch_path("","__meta__/$cur_ver.ops");
  # print @lines;
  print $opt @lines;
  close $opt
}

sub get_track_files {
  my ($version) = @_;
  # version has a default is current version
  $version = (defined $version and $version ne "")?$version: get_cur_ver();

  # fetch all the tracked file from ops
  my @opfiles = glob get_branch_path("","__meta__/*.ops");
  # print join "\n",@opfiles;
  # filter out those not valid for selected version
  @opfiles = grep {$_ =~ /(\d+)/; $1 <= $version} @opfiles;

  my %trackfiles;
  foreach my $file (@opfiles) {
    open my $f,"<", $file;
    map {
      $_=~/([AD]) (.*)/;
      $trackfiles{$2} = 1 if $1 eq "A";
      $trackfiles{$2} = 0 if $1 eq "D";
    } <$f>;

    close $f;
  }

  # return all the currently tracking files
  return keys %trackfiles;
}


# ----
# show file function

sub get_file_path_by_ver{
  my ($version, $file)  = @_;
  # the default value of version is current version
  $version = (defined $version and $version ne "")? $version : get_cur_ver();

  # search till i found the latest version of this file
  for (my $ver = $version; $ver >= 0; $ver--) {
    # show the version of this file;
    # print("searched",get_branch_path("", "$ver/$file"),"\n");
    if(-e get_branch_path("", "$ver/$file")){
      return get_branch_path("", "$ver/$file");
    }
  }
  # ile not found
  return "";
}

sub get_file_content_by_ver {
  # return the content array of the file
  my ($version, $file) = @_;
  # the default value of version is current version
  $version = (defined $version and $version ne "")? $version : get_cur_ver();

  # pop all the tracking files for this version
  my @track_files = get_track_files($version);
  my %track_files = map { $_ => 1 } @track_files;

  # this is not tracking for this version;
  if (! exists $track_files{$file}) {
    return "";
  }

  # fetch the path
  my $path = get_file_path_by_ver($version, $file);
  if ($path eq "") {
    print STDERR "UNDEFINED MESSAGE, FILE IS NOT INDEXED\n";
    exit 1 ;
  }

  open my $f, "<", $path;
  my @content = <$f>;
  close $f;
  # return the read content
  return @content
}



1;
