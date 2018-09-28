#!/usr/bin/env perl
package branchLib;
use warnings;
use strict;
use FindBin;
# import the functionality to make path
use File::Path qw(make_path rmtree);
# self library
use fileLib;
use typeLib;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_db get_curr_commit
get_commit_link add_files get_track_files
);
#
# higher level lib
#
# some handy path
my $INDEX_PATH = ".legit/index/";
my $OPERATION_PATH = ".legit/operation/";
my $COMMIT_PATH  = ".legit/commit/";
# some global variable
my $CURR_BRANCH_KEY = get_meta_path("curr_branch");
# commit start from 0 and it's unique
my $MAX_COMMIT_KEY = get_meta_path("max_commit");
# location of some file
my $BRANCH_RECORD_FILE = get_meta_path("branch");
my $COMMIT_RECORD_FILE = get_meta_path("commit");
my $LOG_RECORD_FILE = get_meta_path("log");
my $INDEX_OPERATION_RECORD_FILE = get_ops_file_path("index");

sub get_index_file_path {
  my ($file) = @_;
  $file = (defined $file) ? $file : "";
  return "$INDEX_PATH/$file";
}

sub get_ops_file_path{
  my ($commit) = @_;
  $commit = (defined $commit) ? $commit : "";
  return $OPERATION_PATH."$commit.ops";
}

sub get_commit_file_path{
  my ($commit,$file) = @_;
  $commit = (defined $commit) ? "$commit/" : "";
  $file = (defined $file) ? $file : "";
  return $COMMIT_PATH.$commit.$file;
}

sub create_branch {
  my ($branch) = @_;
  if ( int(get_key($MAX_COMMIT_KEY)) == 0){
    # couldn't creat branch at no commit state
    dd_err ("legit.pl: error: your repository does not have any commits yet");
  }
  # get current branches
}

sub get_curr_commit{
  my %branches = get_hash_from_file($BRANCH_RECORD_FILE);
  return $branches{get_key($CURR_BRANCH_KEY)};
}

sub init_db {
  # dummy perl
  my %master_hash = ("master" => "-1");
  # create legit file sturecture
  # create a default branch name master
  if (
      ! -d ".legit" and
      make_path(
        $COMMIT_PATH,
        $OPERATION_PATH,
        $INDEX_PATH,
        get_meta_path()
      ) and
      # create all the file for record data
      touch(
        $BRANCH_RECORD_FILE,
        $COMMIT_RECORD_FILE,
        $LOG_RECORD_FILE,
        $INDEX_OPERATION_RECORD_FILE
      ) and
      # current commit is 0
      set_key($MAX_COMMIT_KEY,0) and
      # because create branch will check whether now has commit
      add_hash_to_file($BRANCH_RECORD_FILE, %master_hash) and
      set_key($CURR_BRANCH_KEY,"master")
    ) {
    # init success fully
    return 1;
  }
  return 0;
}


# ==== COMMIT PART ====

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
  # ELSE:
  # set up the data structure to visit
  my @visited;
  my @unvisited = ($commit);
  # get the commit tree
  my %commit_hash = get_hash_from_file($COMMIT_RECORD_FILE);
  # travel throught hash table
  while (my $this_node = shift @unvisited) {
    # add this node to visited
    unshift @visited, $this_node;
    # fetch this node's parent
    my @this_par = split ",",$commit_hash{$this_node} ;
    if (@this_par == 2 or $this_par[0] == -1) {
      # stop search when meeting (merge node or the very first node)
      last;
    }
    # else, push it's parent to @unvisited
    push @unvisited, $this_par[0];
  }
  # return all it's parent
  return @visited;
}


sub get_track_files {
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
  my @commit_link = get_commit_link($commit);
  # get the file name of operations
  unshift @ops_files, @commit_link;

  dd_arr(@ops_files);


  my %track;
  map {
    # this file's operations
    my %ops = get_hash_from_file($_);
    map {
      # map all the operations to the track hash
      $track{$_} = $ops{$_} ;
    } keys %ops;
  } @ops_files;

  # return the whole track
  return %track;
}


sub remove_files {
  # store the operation need to write
  my %delete_ops;
  map {$delete_ops{$_} = "D"} @_;
  add_hash_to_file($INDEX_OPERATION_RECORD_FILE, %delete_ops);

  # remove the file from working directory
  map {if (-e get_index_file_path($_)) {unlink get_index_file_path($_)}} @_;
}

#
sub add_files (\@) {
  my ($files) = @_;

  # change the track file as an hash table
  my %track_files = get_track_files() ;
  # array to be files need to untrack
  my @need_untrack;

  # the not exist file but still tracking
  # see it as the delete action
  # push it into untrack array
  map {
    if (! -e $_) {
      # this file is not exists
      # need to do the untrack
      if (exists $track_files{$_} and $track_files{$_} ne "D") {
        # and this file is tracking
        delete_value_in_array(@$files, $_);
        push @need_untrack, $_;
      }
      else{
        # throw the error and abort the actions
        print STDERR "legit.pl: error: can not open '$_'\n";
        exit 1;
      }
    }
  } @$files;

  # perform the delete action
  remove_files(@need_untrack);

  # moving added files to index
  map {
    copy($_, $INDEX_PATH);
  }

  # track the adding operations
  my %add_hash;
  map{
    # A ass Add, D as Delete
    $add_hash{$_} = "A";
  } @$files;
  add_hash_to_file($INDEX_OPERATION_RECORD_FILE,%add_hash);

  # # track the operations to
  # open  my $op_file, ">>", get_working_ops_file();
  #
  # # copy all files to working directory
  # map {
  #   # get content of both filesystem file and in repo one, compare both
  #   my @src =get_content($_);
  #   my @dest = get_file_content_by_ver("",$_);
  #
  #   if (is_diff(@src, @dest )) {
  #     copy($_, get_index_file_path());
  #     print $op_file "A $_\n";
  #   }
  # } @$files;
  #
  # # close the operation file
  # close $op_file;
}


1;
