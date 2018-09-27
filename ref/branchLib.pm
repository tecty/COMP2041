#!/usr/bin/env perl
package branchLib;
use warnings;
use strict;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_db);
# import the functionality to make path
use File::Path qw(make_path rmtree);

# some global variable
my $META_PATH = get_meta_path();
my $CURR_BRANCH_KEY = construct_key("curr_branch");


sub create_branch {
  my ($branch) = @_;
  my $meta_branch =get_meta_path("branch");
  if(! -e $meta_branch){
    touch($meta_branch);
  }
  

}

# higher level lib
sub init_db {
  # create legit file sturecture
  # create a default branch name master
  if (
      make_path("$META_PATH/commit") and
      make_path("$META_PATH/operation") and
      make_path("$META_PATH/meta") and
      create_branch("master") and
      set_key($CURR_BRANCH_KEY,"master")
    ) {
    # init success fully

    return 1;
  }
  # else: some error occoured

  return 0;
}





1;
