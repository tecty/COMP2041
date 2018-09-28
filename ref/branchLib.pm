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
our @EXPORT = qw(init_db);


# some global variable
my $CURR_BRANCH_KEY = get_meta_path("curr_branch");
# commit start from 0 and it's unique
my $MAX_COMMIT_KEY = get_meta_path("max_commit");
my $HEAD_COMMIT_KEY = get_meta_path("head_commit");
# location of some file
my $BRANCH_RECORD_FILE = get_meta_path("branch");
my $COMMIT_RECORD_FILE = get_meta_path("commit");
my $LOG_RECORD_FILE = get_meta_path("commit");

sub create_branch {
  my ($branch) = @_;
  if ( int(get_key($MAX_COMMIT_KEY)) == 0){
    # couldn't creat branch at no commit state
    dd_err ("legit.pl: error: your repository does not have any commits yet");
  }
  # get current branches

}


# higher level lib
sub init_db {
  # dummy perl
  my %master_hash = ("master" => "-1");
  # create legit file sturecture
  # create a default branch name master
  if (
      ! -d ".legit" and
      make_path(".legit/commit") and
      make_path(".legit/operation") and
      make_path(get_meta_path()) and
      # create all the file for record data
      touch(
        $BRANCH_RECORD_FILE,
        $COMMIT_RECORD_FILE,
        $LOG_RECORD_FILE
      ) and
      # current commit is 0
      set_key($MAX_COMMIT_KEY,0) and
      # there is no commit
      set_key($HEAD_COMMIT_KEY,-1) and
      # because create branch will check whether now has commit
      add_hash_to_file($BRANCH_RECORD_FILE, %master_hash) and
      set_key($CURR_BRANCH_KEY,"master")
    ) {
    # init success fully
    return 1;
  }
  return 0;
}





1;
