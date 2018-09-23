#!/usr/bin/env perl
package dbLib;
use warnings;
use strict;
use Exporter;

# ues path to create a path more easily
use File::Path qw(make_path);

our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_db get_branch_path set_cur_branch get_cur_branch);

sub get_working_directory {
  return ".legit/__meta__/work"
}

sub create_branch {
  my ($branch_name) = @_;
  if (make_path(get_branch_path("master","__meta__"))){
    # successfully
    return 1;
  }

  # error occoured
  return 0;
}

sub set_cur_branch {
  my ($branch) = @_;

  # create a file to record the current branch
  open F, ">", ".legit/__meta__/cur_branch";

  print F $branch;
  close F;
}

sub get_branch_path {
  # this function as a wrapper to generate the path to different
  # branch name
  my ($branch,$sub) = @_;
  # branch would be default to current branch
  $branch = defined $branch? $branch : get_cur_branch();
  # mute the error by setting the default value
  $sub = defined $sub ? $sub: "";
  # generate the path
  return ".legit/$branch/$sub";
}





sub get_cur_branch {

  # create a file to record the current branch
  open my $f, "<", ".legit/__meta__/cur_branch";

  my @lines = <$f>;

  close $f;

  # return the first line, since it only has one line
  return $lines[0];
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

1;
