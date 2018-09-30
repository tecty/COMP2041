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
use textLib;
use pathLib;
use commitTreeLib;
use File::Spec;
use File::Copy;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_db get_curr_commit
get_commit_link add_files get_file_tracks
commit_files get_max_commit
get_log get_file_content_by_commit
remove_files file_status show_remove_error get_curr_status
);

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
# record the message of commit
my $LOG_RECORD_FILE = get_meta_path("log");
my $INDEX_OPERATIONS_FILE = get_operation_path("index");



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

sub get_max_commit{
  # a wrapper for error checking
  return int(get_key($MAX_COMMIT_KEY));
}

sub init_db {
  # dummy perl
  my %master_hash = ("master" => "-1");
  # create legit file sturecture
  # create a default branch name master
  if (
      ! -d ".legit" and
      make_path(
        get_commit_path(),
        get_operation_path(),
        get_index_path(),
        get_meta_path()
      ) and
      # create all the file for record data
      touch(
        $BRANCH_RECORD_FILE,
        $COMMIT_RECORD_FILE,
        $LOG_RECORD_FILE,
        $INDEX_OPERATIONS_FILE
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

sub add_files  {
  my (@files) = @_;

  # change the track file as an hash table
  my %file_track_latest = get_file_tracks() ;
  # array to be files need to untrack
  my @need_untrack;

  # the not exist file but still tracking
  # see it as the delete action
  # push it into untrack array
  map {
    if (! -e $_) {
      # this file is not exists
      # need to do the untrack
      if (exists $file_track_latest{$_}) {
        # and this file is tracking
        remove_value_from_array(@files, $_);
        push @need_untrack, $_;
      }
      else{
        # throw the error and abort the actions
        dd_err ("legit.pl: error: can not open '$_'");
      }
    }
  } @files;

  # perform the delete action
  remove_files(@need_untrack);

  # Edge Case:
  # file is tracking, but delete in index,
  # add a same file in tracking
  my @key_remove_needed;

  # get all the currently operations
  my %index_ops = get_hash_from_file($INDEX_OPERATIONS_FILE);

  map {
    if (exists $index_ops{$_} and $index_ops{$_} eq "D"){
      # this file need to remove the delete flag first
      push @key_remove_needed,$_;
    }
  } @files;

  # remove all the keys from operation file
  delete_hash_from_file($INDEX_OPERATIONS_FILE, @key_remove_needed);

  # update the track is needed
  %file_track_latest = get_file_tracks();


  # moving added files to index
  map {
    my @src_content = get_file_content_by_tracks($_, $file_track_latest{$_});
    my @dest_content = get_content($_);
    if (
      # not record in repo
      ! exists $file_track_latest{$_} or
      # track content is diff from working
      is_diff(@src_content, @dest_content)
    ) {
      # there is different between this version and the version in repo
      copy($_, get_index_path());
    }
    else {
      # there is no difference, no perform add
      remove_value_from_array(@files, $_);
    }
  } @files;

  # track the adding operations
  my %add_hash;
  map{
    # A ass Add, D as Delete
    $add_hash{$_} = "A";
  } @files;
  add_hash_to_file($INDEX_OPERATIONS_FILE,%add_hash);
}

sub add_commit {
  # #pre: there's things to commit
  my ($message) = @_;

  # this commit's id
  # increment it and store
  my $commit_id = int(get_key($MAX_COMMIT_KEY));
  set_key($MAX_COMMIT_KEY, $commit_id +1);

  # point commit_id to current commit (HEAD)
  my %commit_link = ( $commit_id => get_curr_commit());
  add_hash_to_file($COMMIT_RECORD_FILE, %commit_link);


  # point this branch's head to this commit
  my %branch_id = (get_key($CURR_BRANCH_KEY) =>  $commit_id);
  add_hash_to_file($BRANCH_RECORD_FILE, %branch_id);

  my @indexed_files = glob(get_index_path("*"));
  push @indexed_files, glob(get_index_path(".*"));
  # move all the thing from index to commit dir
  make_path(get_commit_path($commit_id));
  map {
    move($_,get_commit_path($commit_id))
  } @indexed_files;

  # rename the operation's file and create a new one
  move($INDEX_OPERATIONS_FILE, get_operation_path($commit_id));
  touch($INDEX_OPERATIONS_FILE);

  # record the commit message
  my %message_hash = ($commit_id => $message);
  add_hash_to_file($LOG_RECORD_FILE, %message_hash);
}

sub commit_files{
  my ($commit) = @_;

  # get the content in the operation file, to decide whether there's things
  # to commit
  my %op_content = get_hash_from_file($INDEX_OPERATIONS_FILE);

  if (keys %op_content == 0) {
    # commit fail
    dd_err("nothing to commit");
  }
  else {
    add_commit($commit);
    print "Committed as commit ",get_curr_commit(),"\n";
  }
}

sub get_file_content_by_tracks($\@) {
  # take two argument, filename and the track of this file
  my ($file, $track_ref) = @_;
  if (defined $track_ref and $#$track_ref != -1) {
    # the file has track  -- protection
    # get the content by the latest commit's path
    return get_content(
    get_commit_path(
    $$track_ref[$#$track_ref] , $file
    ));
  }
  # there's no track
  return "";
}

sub get_file_content_by_commit {
  my ($file, $commit) = @_;
  # this is just get the file content fronend function
  # use this a lot will cost performance issue
  my %file_track = get_file_tracks($commit);
  if (! defined $file_track{$file}) {
    if (defined $commit and $commit ne "" ) {
      # (commit != null and path == null ) => couldn't find in commit
      dd_err("legit.pl: error: '$file' not found in commit $commit");
    }
    else{
      # (commit == null and path == null ) => couldn't find in index
      dd_err("legit.pl: error: '$file' not found in index");
    }
  }

  return get_file_content_by_tracks($file, @{ $file_track{$file}} );
}

sub get_log {
  # return the parsed array of log
  my %log_hash = get_hash_from_file($LOG_RECORD_FILE);
  # for storing the parsed log
  my @log_arr;
  foreach my $key (
    # numeric sort of the hash keys
    reverse sort {$a <=> $b} keys %log_hash
  ) {
    push @log_arr, "$key $log_hash{$key}\n";
  }
  # return the parsed array
  return @log_arr;
}

# ==== REMOVE PART ====
sub remove_files {
  # remove the file from working directory
  map {if (-e get_index_path($_)) {unlink get_index_path($_)}} @_;

  # filter out those don't need to record the operations
  my %tracks = get_file_tracks(get_curr_commit());
  map {
    if (! exists $tracks{$_}){
      # this file not need to record the operation
      # because it's not in the repo
      remove_value_from_array(@_, $_);
    }
  } @_;

  # store the operation need to write
  my %delete_ops;
  map {$delete_ops{$_} = "D"} @_;
  add_hash_to_file($INDEX_OPERATIONS_FILE, %delete_ops);
}

# return a hash table of status
sub file_status  {
  #  F I R (File system, Indexed, Repository)
  #        Appear
  #        Different
  #        Remove
  # File System Different - special case, the file is removed in index

  my @files = @_;
  # hash array for status
  my %status ;

  # hashing of current operations ;
  my %index_ops = get_hash_from_file($INDEX_OPERATIONS_FILE);
  # hash of current commit's tracking, not index;
  my %curr_commit_tracks = get_file_tracks(get_curr_commit());

  # check all specified file status
  foreach my $file  (uniq sort @files) {
    if (-e $file ) {
      $status{$file} .= "A";
      if (exists $index_ops{$file} and $index_ops{$file} eq "D") {
        $status{$file} = "D";
      }
    }
    else {
      $status{$file} = "R";
      # mark this file as deleting
      if (exists $index_ops{$file} and $index_ops{$file} eq "D") {
        $status{$file} = "D";
      }
      # only need to check wether it's Appear in the $working_dir or repository
      if(-e get_index_path($file)) {
        $status{$file} .= "A";
      }
      else{
        $status{$file} .= "R";
      }

      # whether it's track in repository
      if (exists $curr_commit_tracks{$file} ){
        $status{$file} .= "A";
      }
      else{
        $status{$file} .= "R";
      }
      # short circute remain checks
      next;
    }
    # ==== the file exist, we need to perform difference check

    # open the file and read the content inside
    my @fs_content =  get_content($file);

    # check the content in working directory
    if (-e get_index_path($file)) {
      my @index_content = get_content(get_index_path($file));
      if (is_diff(@index_content,@fs_content)){
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
    if (exists $curr_commit_tracks{$file}) {
      # get the repository record's content
      my @rep_content =
        get_file_content_by_tracks($file,@{$curr_commit_tracks{$file}});
      # there is different set "D", otherwise set A
      if(is_diff(@rep_content, @fs_content)){
        $status{$file} .= "D";
      } else{
        $status{$file} .= "A";
      }
    }
    else{
      $status{$file} .= "R";
    }
  }

  return %status;
}

sub show_remove_error{
  my ($file,$status) = @_;
  if ($status =~/ADD/) {
    dd_err("legit.pl: error: '$file' in index is different to both working file and repository");
  }
  elsif ($status =~/AA./) {
    dd_err("legit.pl: error: '$file' has changes staged in the index");
  }
  elsif ($status =~/A[AR]D/) {
    dd_err("legit.pl: error: '$file' in repository is different to working file");
  }


  elsif ($status =~/[DA]R[RD]/) {
    dd_err("legit.pl: error: '$file' is not in the legit repository");
  }
}

sub get_curr_status{
  # currently tracking
  my %file_track = get_file_tracks(get_curr_commit());
  my @indexed_files = keys %file_track;
  # current delteing file
  # my %curr_ops = get_hash_from_file($INDEX_OPERATIONS_FILE);
  # push @indexed_files, keys %curr_ops;
  # content in current directory
  push (@indexed_files,glob("*"));
  # remove duplicate check
  @indexed_files = uniq(@indexed_files);
  return file_status(@indexed_files)
}
1;
