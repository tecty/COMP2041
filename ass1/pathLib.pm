#!/usr/bin/env perl
package pathLib;
use warnings;
use strict;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(
get_index_path get_operation_path get_commit_path
);

my $OPERATION_PATH = ".legit/operation/";
my $COMMIT_PATH  = ".legit/commit/";
my $INDEX_PATH = get_commit_path("index");

# low level library to provide settings
# this is an API for explore commit tree
sub get_index_path {
  my ($file) = @_;
  $file = (defined $file) ? $file : "";
  return "$INDEX_PATH/$file";
}

sub get_operation_path{
  my ($commit) = @_;
  $commit = (defined $commit) ? "$commit.ops" : "";
  return $OPERATION_PATH.$commit;
}

sub get_commit_path{
  my ($commit,$file) = @_;
  $commit = (defined $commit) ? "$commit/" : "";
  $file = (defined $file) ? $file : "";
  return $COMMIT_PATH.$commit.$file;
}
