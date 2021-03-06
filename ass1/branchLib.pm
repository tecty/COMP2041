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
our @EXPORT = qw(
init_db get_curr_commit
get_commit_link add_files get_file_tracks
commit_files get_max_commit
get_log get_file_content_by_commit
remove_files file_status show_remove_error get_curr_status

is_branch_exist
pre_checkout_routine checkout_to_branch
is_ancestor_of_some_branch
create_branch delete_branch
get_all_branches
do_merge merge_commit
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

sub is_branch_exist{
  # checking whether a branch is exist
  my %branches = get_all_branches();
  return exists $branches{$_[0]};
}


sub is_ancestor_of_some_branch {
  my ($branch) = @_;
  # my %commit_hash = get_commit_hash();
  # get the branch name of all branch, except this one
  my %branches_hash =  get_hash_from_file($BRANCH_RECORD_FILE);
  my @branches = keys %branches_hash;
  remove_value_from_array(@branches, $branch);

  # find all possible branches_hash
  map {
    if ($branches_hash{$_} == $branches_hash{$branch} ){
      # dd_var("return true here with $_ $branch");
      # the head is same
      return 1;
    }
    elsif ($branches_hash{$_} > $branches_hash{$branch} ){
      # find whether this branch has ancsetor of given branch
      if (is_ancestor_of($branches_hash{$branch},$branches_hash{$_})){
        return 1;
      }
    }
    # ELSE: pass to next branch to test
  } @branches;

  # not found
  return 0;
}

sub delete_branch{
  my ($branch) = @_;
  if(! is_branch_exist($branch)){
    # error of couldn't delte
    dd_err("legit.pl: error: branch '$branch' does not exist");
  }
  elsif($branch eq "master"){
    # master has delete protection
    dd_err("legit.pl: error: can not delete branch '$branch'");
  }
  elsif(! is_ancestor_of_some_branch($branch)){
    # prevent it from deletion if it's not the ancestor of other branches
    dd_err("legit.pl: error: branch '$branch' has unmerged changes");
  }

  # else, perform the deletion
  delete_hash_from_file($BRANCH_RECORD_FILE,@_);
}

sub create_branch {
  my ($branch) = @_;
  # get current branches
  if (is_branch_exist($branch)){
    # branch should be not exits
    dd_err("legit.pl: error: branch '$branch' already exists");
  }
  # ELSE:
  my %new_branch_record = ($branch => get_curr_commit());
  add_hash_to_file($BRANCH_RECORD_FILE, %new_branch_record);
}

sub remove_changes_in_index {
  # the path of files need to be unlink
  my @index_path;
  foreach my $file (@_) {
    push @index_path, get_index_path($file);
  }
  unlink @index_path;
  # remove all the changes in index
  delete_hash_from_file($INDEX_OPERATIONS_FILE, @_);
}

sub pre_checkout_routine {
  my ($branch) = @_;
  if (! is_branch_exist($branch)){
    # unknown branch error
    dd_err("legit.pl: error: unknown branch '$branch'");
  }
  if ($branch eq get_key($CURR_BRANCH_KEY)) {
    dd_err("Already on '$branch'");
  }
}

sub checkout_to_branch {
  my ($branch) = @_;
  # fetch all the branch records
  my %branches_record = get_hash_from_file($BRANCH_RECORD_FILE);
  # get the files track of both branch
  my %this_tracks = get_file_tracks(
    $branches_record{get_key($CURR_BRANCH_KEY)}
  );
  my %that_tracks = get_file_tracks(
    $branches_record{$branch}
  );

  # === persist changes check
  map {
    if (-e $_){
      # TODO: Whether a delete is a changes need to persist
      # $_ will be the file name that this branch is currently tracking
      my @fs_content = get_content($_);
      my @this_content = get_file_content_by_tracks($_, $this_tracks{$_});
      if (is_diff(@fs_content, @this_content)) {
        # persist the changes
        delete $this_tracks{$_};
        delete $that_tracks{$_};
      }
    }
  } keys %this_tracks;


  # === overwritten check

  # to record those files changes that might  discarded
  my @overwritten_files;
  # the changing is overwritten if thereis a file here
  map {
    # skip for this working dir doesn't have the file
    if (-e $_ ) {
      # $_ will be the file name that "that branch" is currently tracking
      my @fs_content = get_content($_);
      my @that_content = get_file_content_by_tracks($_, $that_tracks{$_});

      if (! exists $this_tracks{$_}) {
        # those will be overwritten is the file that in fs and system want to
        # persist it's changes
        push @overwritten_files, $_;
      }
    }
  } keys %that_tracks;

  if (@overwritten_files != 0){
    # fatal overwritten error
    dd_err(
      "legit.pl: error: Your changes to the following files would be overwritten by checkout:\n".
      join("\n", @overwritten_files)
    )
  }

  # remove all the needed to remove
  unlink keys  %this_tracks;

  # checkout to required branch in logic
  set_key($CURR_BRANCH_KEY, $branch);

  # reconstruct the file in directory
  map {
    # $_ is the file name of this branch currently tracking
    my @fs_content = get_file_content_by_tracks($_, $that_tracks{$_});
    set_content($_,@fs_content);
  } keys %that_tracks;

}

sub get_all_branches{
  return get_hash_from_file($BRANCH_RECORD_FILE);
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
    elsif (! -f $_) {
      dd_err("legit.pl: error: '$_' is not a regular file")
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

  # get the tracks of current commit to calculate diff
  my %file_tracks = get_file_tracks(get_curr_commit());
  # dd_arr("A's track", @{$file_tracks{"b"}});

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
  #
  my %index_ops = get_hash_from_file($INDEX_OPERATIONS_FILE);
  my @indexed_files  = grep { $_ if $index_ops{$_} eq "A"} keys %index_ops;
  # dd_arr("index_arr",@indexed_files);


  # move all the thing from index to commit dir
  make_path(get_commit_path($commit_id));
  map {
    # $_ is the file name
    # dd_var("file_name", $_) if $_ eq "b";

    if (! defined $file_tracks{$_}){
      # becuse this file haven't been tracked
      # this is the base of the file
      move(get_index_path($_),get_commit_path($commit_id));
    }
    else{
      # dd_var("defined") if $_ eq "b";
      # this file has tracked, we need to get it's content and write it's diff
      # dd_var("_",$_) if $_ eq "b";
      my @dest = get_content(get_index_path($_));
      my @base = get_file_content_by_tracks($_, $file_tracks{$_});
      pop_newline(@base);
      pop_newline(@dest);
      my %diff = diff(@base, @dest);
      # dd_hash("diff",%diff);
      # write the diff to file
      my @content = hashSerializer(%diff);
      set_content(get_commit_path($commit_id,$_), @content);
      # we don't need the file in index any more
      unlink get_index_path($_);
    }
  } @indexed_files;

  # dd_var("fail save");

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
    return 0;
  }
  else {
    add_commit($commit);
    return 1;
  }
}

sub get_file_content_by_tracks($\@) {
  # take two argument, filename and the track of this file
  my ($file, $track_ref) = @_;
  if (defined $track_ref and $#$track_ref != -1) {
    # special case, we need to directly pop the content from index
    # dd_var("last path",$$track_ref[$#$track_ref]);
    if($$track_ref[$#$track_ref] eq "index"){
      return get_content(
        get_commit_path($$track_ref[$#$track_ref] , $file
      ));
    }
    # the file has track  -- protection
    # get the content by the latest commit's path
    my @base = get_content(get_commit_path($$track_ref[0] , $file));
    pop_newline(@base);
    # for the rest of the file, we assume them is store in diff
    for (my $index = 1; $index <= $#$track_ref; $index++) {
      # diff is store by a hash
      my %diff = get_hash_from_file(
        get_commit_path($$track_ref[$index] , $file));

      # add up this diff
      @base = patch(@base, %diff);
    }

    push_newline(@base);

    return @base;
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
  my @commit_link = get_full_commit_link();
  foreach my $key (
    # numeric sort of the hash keys
    reverse @commit_link
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
      my @rep_content =get_file_content_by_tracks($file,@{$curr_commit_tracks{$file}});
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
  elsif ($status =~/.R[RD]/) {
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

# ==== MERGE PART ====

sub fetch_files_hash_by_commit {
  my ($commit) = @_;
  my %files;
  my %file_tracks = get_file_tracks($commit);
  foreach my $file_name (keys %file_tracks) {
    my @content= get_file_content_by_tracks(
      $file_name, @{$file_tracks{$file_name}});
    # we dont want new line when diff
    pop_newline(@content);
    $files{$file_name}  = [@content];
  }
  # return the files;
  return %files;
}

sub fetch_ops_by_commit{
  my ($from, $to) = @_;
  # fetch the commit link
  my @commit_link = get_commit_link($from, $to);
  # remove the operation in ancestor, because ancestor's operation is
  # the operation between ancestor's parent and ancestors
  shift @commit_link;

  # the final opearation array ;
  my %ops;
  foreach my $this_commit (@commit_link) {
    my %tmp_ops = get_hash_from_file(get_operation_path($this_commit));
    foreach my $key (keys %tmp_ops) {
      # add up this operations
      $ops{$key} = $tmp_ops{$key};
    }
  }
  # return the final operations
  return %ops;
}

sub get_diff_by_file_set(\%\%) {
  my ($src_ref, $dest_ref) = @_;
  my %diff_result;
  # push to array's file
  my @files = keys %$src_ref;
  push @files, keys %$dest_ref;

  # remove the direct reference to prevent a bug
  my %src = %$src_ref;
  my %dest = %$dest_ref;


  # the file_name should be unique
  @files = uniq(@files);

  foreach my $file_name (@files) {
    # fetch the content and diff
    if (! defined $$src_ref{$file_name}) {
      # assign an empty array
      $src{$file_name} = [];
    }
    if (! defined $$dest_ref{$file_name}) {
      # assign an empty array
      $dest{$file_name} = [];
    }
    # generate the diff and dump it to diff's hash
    my @src = @{$src{$file_name}};
    my @dest = @{$dest{$file_name}};
    # 2-D hash or 2-D array is painful in perl
    # because perl doesn't have type system ? or strong type?
    # I miss php
    # much better scripting lang
    my %diff_out = diff(@src, @dest);
    $diff_result{$file_name} = {%diff_out} ;
  }

  return %diff_result;
}

sub merge_diff_by_file(\%\%) {
  my ($src_ref, $dest_ref) = @_;
  my %merged_diff;
  # try to merge this diff
  my @actions = keys %$src_ref;
  push @actions , keys %$dest_ref;
  # return ();

  foreach my $key (@actions) {
    $key =~ /([0-9]*)([ADC])([0-9]*)/;
    my $line = $1;
    my $operation = $2;
    if (defined $$dest_ref{$key} and defined $$src_ref{$key}  ) {
      # this operation has defined in both branch
      # if the argument is not same, then this file couldnt' merge
      if ($$src_ref{$key} ne $$dest_ref{$key}) {
        # couldn merge if they both try to modify same line
        return ;
      }
      # dd_err("i was here $$dest_ref{$key}");
      # this operation can be merge
      $merged_diff{$key} = $$dest_ref{$key};
    }
    else{
      # reverse the operation to check the other hash
      if ($operation eq "D"){
        $operation = "C";
      }
      elsif ($operation eq "C"){
        $operation = "D";
      }
      if (defined $$dest_ref{$key}) {
        if (defined $$src_ref{$line.$operation} and $operation ne "A") {
          # "A" operation doesn't need to check the reverse
          # this file cannot merge
          return ;
        }
        # this operation can be merge
        $merged_diff{$key} = $$dest_ref{$key};
      }else{
        # this operation is from src
        if (defined $$dest_ref{$line.$operation} and $operation ne "A") {
          # "A" operation doesn't need to check the reverse
          return ;
        }
        $merged_diff{$key} = $$src_ref{$key};
      }
    }
  }

  return %merged_diff;
}

sub get_their_commit_id {
  my ($their_commit) = @_;
  my %branch_hash = get_hash_from_file($BRANCH_RECORD_FILE);
  if (! is_int($their_commit)){
    # convert their banch as commit id
    $their_commit = $branch_hash{$their_commit};
  }
  return int($their_commit);
}

sub do_merge {
  # fetch their commit id
  my $their_commit = get_their_commit_id(@_);
  my $our_commit = get_curr_commit();
  my @need_auto_merge;

  if (is_ancestor_of($their_commit, $our_commit)) {
    # merge our ancestor's error
    print "Already up to date\n";
    exit 0;
  }


  if(is_ancestor_of($our_commit,$their_commit) ){
    # I can fast forward commit here
    # by just set out branch point to their's commit id

    my %new_record = (get_key($CURR_BRANCH_KEY) => $their_commit);
    add_hash_to_file(
      $BRANCH_RECORD_FILE,%new_record
    );
    # perform a fake checkout
    checkout_to_branch(get_key($CURR_BRANCH_KEY));
    # abort commit, there's nothing to commit
    # not need commit
    return 0;
  }
  else {
    # merge ther commit to our commit
    my @ancestors = get_ancestor($their_commit, $our_commit);
    # fetch the best ancsetor
    my $best_ancestor = $ancestors[0];

    # fetch all operations of both branches
    my %our_ops = fetch_ops_by_commit($our_commit, $best_ancestor);
    my %their_ops = fetch_ops_by_commit($their_commit, $best_ancestor);



    my %merged_ops = %their_ops;


    my @unable_merge;
    # check whether there is a conflict in the operation first
    foreach my $key  (sort keys %our_ops) {
      if (defined $their_ops{$key}) {
        # then checking whether a branch has deleted the file for now
        if ($their_ops{$key} ne $our_ops{$key}) {
          # we currently record add and delete
          # then if it's different then the operation couldn't merge
          push @unable_merge, $key;
        }
        else{
          # dd_var("$their_ops{$key} ne $our_ops{$key}");
          # this file need auto mergeing
          push @need_auto_merge, $key;
        }
      }
      else{
        # not defined
        # merge this oepration
        $merged_ops{$key} = $our_ops{$key};
      }
    }

    # do the three way merge
    my %ancestor_files= fetch_files_hash_by_commit($best_ancestor);
    my %our_files= fetch_files_hash_by_commit($our_commit);
    my %their_files= fetch_files_hash_by_commit($their_commit);


    map {
      # remove all the files that's unable merged from tracks first
      delete $ancestor_files{$_};
      delete $our_files{$_};
      delete $their_files{$_};
    } @unable_merge;

    # get the file set diff
    my %our_diff = get_diff_by_file_set(%ancestor_files, %our_files);
    my %their_diff = get_diff_by_file_set(%ancestor_files, %their_files);
    # dd_hash("our_diff", %ancestor_files);


    # dd_arr("ancestor's 7", @{$their_files{"7.txt"}});
    # generate merged diff, which can apply to ancestor
    my %merged_diff;

    # fetch all the file name
    my @check_files = keys %our_diff;
    push @check_files, keys %their_diff;
    @check_files = uniq(@check_files);
    # dd_arr("Check merging files",@check_files);

    foreach my $file (sort @check_files) {
      if (!defined $our_diff{$file}) {
        # then the merged result is their diff's result
        $merged_diff{$file} = $their_diff{$file};
        next;
      }
      if (!defined $their_diff{$file}) {
        # then the merged result is their diff's result
        $merged_diff{$file} = $our_diff{$file};
        next;
      }

      # merged diff to be the result
      $merged_diff{$file} =
        {merge_diff_by_file(%{$our_diff{$file}} , %{$their_diff{$file}})};
      # dd_hash( "merged ops ",%{$merged_diff{$file}});
      if (! keys %{$merged_diff{$file}} and
        # prevent both diff is empty
        # Etc: empty file situation.
        (keys %{$their_diff{$file}} or keys %{$our_diff{$file}})) {
        # unable to merge two diff
        push @unable_merge, $file;
      }
    }
    # debug window
    # dd_hash("merged diff", %{$merged_diff{"7.txt"}});
    # dd_hash("merged ops", %merged_ops);

    # dump the merge error
    if (@unable_merge) {
      # prevent duplicate unable merge file
      @unable_merge =  uniq(@unable_merge);
      @unable_merge = sort @unable_merge;
      dd_err(
      "legit.pl: error: These files can not be merged:\n" .join("\n",@unable_merge));
    }

    # === Perform merge actually
    # there's not way back, have to perform merge now
    # now we should checked all our errors situations

    # TODO: now is assumed the index is empty

    # sematic: apply merged diff to ancestors
    foreach my $file (@check_files) {
      # I hate this syntax, even i know why
      my @dest = patch(@{$ancestor_files{$file}}, %{$merged_diff{$file}});
      push_newline(@dest);
      # write the merged output to the index folder
      set_content(get_index_path($file), @dest);

      # perform as checkout to this created commit
      set_content($file, @dest);
    }

    # set up the merged operations, i don't think it's matter
    set_hash_to_file($INDEX_OPERATIONS_FILE, %merged_ops);
  }
  print ("Auto-merging $_\n") for @need_auto_merge;
  # need commit
  return 1;
}

sub merge_commit{
  # fetch this commit's arguments
  my $message = $_[1];
  my $their_commit = get_their_commit_id($_[0]);
  my $our_commit = get_curr_commit();
  # full copy because we assume the

  # === Using My NoSQL Access APIs
  # this commit's id
  # increment it and store
  my $commit_id = int(get_key($MAX_COMMIT_KEY));
  set_key($MAX_COMMIT_KEY, $commit_id +1);

  # point commit_id to two branches head (HEAD)
  my %commit_link = ( $commit_id => "$our_commit,$their_commit");
  add_hash_to_file($COMMIT_RECORD_FILE, %commit_link);

  # point this branch's head to this commit
  my %branch_id = (get_key($CURR_BRANCH_KEY) =>  $commit_id);
  add_hash_to_file($BRANCH_RECORD_FILE, %branch_id);

  my %index_ops = get_hash_from_file($INDEX_OPERATIONS_FILE);
  my @indexed_files  = grep { $_ if $index_ops{$_} eq "A"} keys %index_ops;
  # dd_arr("index_arr",@indexed_files);

  # move all the thing from index to commit dir
  make_path(get_commit_path($commit_id));
  map {
    # copy all the record
    move(get_index_path($_),get_commit_path($commit_id));
  } @indexed_files;

  # dd_var("fail save");

  # rename the operation's file and create a new one
  move($INDEX_OPERATIONS_FILE, get_operation_path($commit_id));
  touch($INDEX_OPERATIONS_FILE);

  # record the commit message
  my %message_hash = ($commit_id => $message);
  add_hash_to_file($LOG_RECORD_FILE, %message_hash);
}

1;
