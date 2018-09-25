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

my @indexed_files = get_track_files();
print $#indexed_files;
push (@indexed_files,glob("*"));
# print join "\n", glob ("*");

print join "\n", @indexed_files;
@indexed_files = uniq(sort @indexed_files);
my %status = file_status(@indexed_files);
# print %status;
