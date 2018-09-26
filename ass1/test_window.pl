#!/usr/bin/env perl
use warnings;
use strict;

use Error;
# use Text::Diff;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our base lib
use baseLib;
use dbLib;

# my @indexed_files = get_track_files();
# push (@indexed_files,glob("*"));
# print $#indexed_files;

# print join "\n", glob ("*");

# print join "\n", @indexed_files;
# @indexed_files = uniq(sort @indexed_files);
# my %status = file_status(qw(a b c e));
# print %status,"\n";
#
# print get_working_delete();
#
#
# # hashing of deleting files;
# my %deleting;
# map {$deleting{$_}=1 } get_working_delete;

# print file_status(qw(a));
# woring_ops_duplicate_remove();
# print get_content(get_working_ops_file());

print file_status(qw(a c));
