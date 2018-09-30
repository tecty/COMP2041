#!/usr/bin/env perl
package commitTreeLib;
use warnings;
use strict;
use FindBin;
# import the functionality to make path
use File::Path qw(make_path rmtree);
# self library
use fileLib;
use typeLib;
use textLib;
use pathLib;
use File::Copy;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(
get_curr_commit get_max_commit get_commit_link get_file_tracks
);

# middle ware?
# this is an API for explore commit tree

#
# higher level lib
#
# some handy path
# some global variable
my $CURR_BRANCH_KEY = get_meta_path("curr_branch");
# commit start from 0 and it's unique
my $MAX_COMMIT_KEY = get_meta_path("max_commit");
# location of some file
my $BRANCH_RECORD_FILE = get_meta_path("branch");
# record the path of commit
my $COMMIT_RECORD_FILE = get_meta_path("commit");

sub get_curr_commit{
  my %branches = get_hash_from_file($BRANCH_RECORD_FILE);
  return $branches{get_key($CURR_BRANCH_KEY)};
}

sub get_max_commit{
  # a wrapper for error checking
  return int(get_key($MAX_COMMIT_KEY));
}

sub get_commit_link {
  my ($commit) = @_;
  # stop at two value node (merge)
  # or get a accendign list (by history )
  if (!(defined $commit and $commit ne "")) {
    # fetch the default value from fs
    $commit = get_curr_commit();
  }
  # change type of the commit value
  $commit = int($commit);

  if ($commit == -1) {
    # return an empty array
    return ();
  }
  if ($commit >= get_max_commit()) {
    dd_err("legit.pl: error: unknown commit '$commit'");
  }

  # ELSE:
  # set up the data structure to visit
  my @visited;
  my @unvisited = ($commit);
  # get the commit tree
  my %commit_hash = get_hash_from_file($COMMIT_RECORD_FILE);
  # travel throught hash table
  while (@unvisited) {
    my $this_node = shift @unvisited;
    # add this node to visited
    unshift @visited,$this_node;
    # fetch this node's parent
    my @this_par = split ",",$commit_hash{$this_node} ;
    # push it's parent to @unvisited
    push @unvisited, $this_par[0];
    if (@this_par == 2 or int($this_par[0]) == -1) {
      # stop search when meeting (merge node or the very first node)
      last;
    }
  }
  # return all it's parent
  return @visited;
}

sub get_file_tracks {
  # not defined or "" is mean latest,
  # which will include the result in indexed
  my ($commit) = @_;
  my @ops_files;
  if (!(defined $commit and $commit ne "")) {
    # not define the commit, latest commit is needed
    $commit = get_curr_commit();
    # push the index record file
    push @ops_files, "index";
  }
  elsif (int($commit) > int(get_key($MAX_COMMIT_KEY))) {
    # prevent the commit > max_commit
    dd_err("legit.pl: error: unknown commit '$commit'")
  }


  my @commit_link = get_commit_link($commit);
  # get the file name of operations
  unshift @ops_files, @commit_link;

  my %track;
  map {
    # the ops_files just commit's id (and special case "index")

    # this file's operations
    my %ops = get_hash_from_file(get_operation_path($_));
    foreach my $key (keys %ops) {
      # push the commit version to the file
      if ($ops{$key} eq "A") {
        # perform a add in tracks
        # add this commit at the end
        push @{$track{$key}}, $_;
      }
      else{
        # untrack in this commit
        delete $track{$key};
      }
    }
  } @ops_files;

  # return the whole track
  return %track;
}

1;
