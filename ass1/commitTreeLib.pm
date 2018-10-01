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
get_commit_hash
get_ancestor do_get_ranged_commit_link
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

sub get_commit_hash {
  my %commit_hash = get_hash_from_file($COMMIT_RECORD_FILE);
  foreach my $key (keys %commit_hash) {
    my @arr = split(",",$commit_hash{$key});
    # strictly change type to int
    map {$_ = int($_)} @arr;
    $commit_hash{$key} = [@arr];
    # print "im with ", @{$commit_hash{$key}}, "\n";
  }
  # dd_hash("commit hash ", %commit_hash);
  return %commit_hash;
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
  my %commit_hash = get_commit_hash();

  # travel throught hash table
  while (@unvisited) {
    my $this_node = shift @unvisited;
    # add this node to visited
    unshift @visited,$this_node;
    # fetch this node's parent
    my @this_par = @{$commit_hash{$this_node}} ;
    # dd_arr("this parent", @this_par);
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

sub do_get_ranged_commit_link($$\%\%) ;
sub do_get_ranged_commit_link($$\%\%) {
  # four input value, do the search recursively
  my ($commit_id, $depth, $hash_ref, $ret_ref) = @_;
  # set this commit id as input
  if (!defined $commit_id or $commit_id <= -1) {
    # break the search, since there's no parent for -1 commit
    return;
  }
  # if ($depth == 100) {
  #   print "array ",$$hash_ref{$commit_id};
  #   dd_arr("input", @_);
  # }


  # assign the depth
  ${$ret_ref}{$commit_id}= $depth ;
  # find the next node to visit
  my @next = @{$$hash_ref{$commit_id}};
  foreach (@next) {
    do_get_ranged_commit_link($_, $depth +1, %$hash_ref, %$ret_ref);
  }
}

sub get_ranged_commit_link{
  my ($commit, %commit_hash ) = @_;
  if ($commit == -1) {
    # return an empty array
    return ();
  }
  if ($commit >= get_max_commit()) {
    dd_err("legit.pl: error: unknown commit '$commit'");
  }

  # store the value of return
  # with (commit => depth)
  my %ret ;
  do_get_ranged_commit_link($commit, 0, %commit_hash, %ret);
  return %ret;
}

sub is_ancestor_of ($$\%) {
  # pre $from > $to ;
  my ($from, $to, $hash_ref) = @_;

  my @visited;
  my @unvisited = ($from);
  # get the commit tree
  my %commit_hash = get_commit_hash();
  # travel throught hash table
  while (@unvisited) {
    my $this_node = shift @unvisited;
    # add this node to visited
    unshift @visited,$this_node;
    # fetch this node's parent
    my @this_par = @{$commit_hash{$this_node}} ;
    # push it's parent to @unvisited
    push @unvisited, @this_par;
    if ($to == $this_node){
      return 1;
    }
    if (($this_par[0] < $to )and ($this_par[1] < $to) ) {
      # not found
      return 0;
    }
  }
  return 0;
}

sub get_ancestor {
  # input is two commit id
  my ($mine, $theirs) = @_;

  my %commit_hash = get_commit_hash();

  # get the ranged commit link
  my %mine_link = get_ranged_commit_link($theirs, %commit_hash);
  my %theirs_link = get_ranged_commit_link($mine, %commit_hash);

  # push all the common part
  my @ancestors;
  foreach my $commit (keys %mine_link) {
    if (exists $theirs_link{$commit}){
      push @ancestors, $commit;
    }
  }

  # decending sort of the ancestors
  # done use reverse of a and b because it is not Intuitive
  @ancestors = reverse sort {$a <=> $b} @ancestors;

  # TODO: If i do recursive merge, i will need to remove the not good ancestor
  #       But for now, I leave it there

  # # remove all the one ancestors is another's ancestors;
  # for (my $index = 0; $index < @ancestors; $index++) {
  #   if (is_ancestor_of($ancestors[$index], $$ancestors[$index + 1])) {
  #     # remove the index +1 as the ancestor
  #   }
  #
  # }

  return @ancestors;
}


1;
