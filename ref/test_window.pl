#!/usr/bin/env perl
use warnings;
use strict;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# import all
use branchLib;
use controller;
use fileLib;
use helperLib;
use typeLib;
# this script for testing
my %hash;
$hash{0}= "-1";
$hash{1}= "0";
$hash{2}= "1,0";
$hash{3}= "2";
$hash{4}= "3";
my $COMMIT_RECORD_FILE = get_meta_path("commit");

add_hash_to_file($COMMIT_RECORD_FILE, %hash);
# dd_val(get_curr_commit());

# dd_arr("commit_link",get_commit_link());
get_track_files()
