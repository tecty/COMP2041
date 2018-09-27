#!/usr/bin/env perl
package dbLib;
use warnings;
use strict;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_db);

# some global variable
# my $CURR_BRANCH_KEY = ".legit/" 


# higher level lib
sub init_db {
  # create legit file sturecture
  # create a default branch name master
  if (
      make_path(get_working_file_path()) and
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
