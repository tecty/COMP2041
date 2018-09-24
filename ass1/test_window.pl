#!/usr/bin/env perl
use warnings;
use strict;

# use Text::Diff;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our base lib
use baseLib;
use dbLib;

# print get_track_files(3);
print get_file_path_by_ver("","a");
print file_status(qw("a"));
