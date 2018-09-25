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

# print get_track_files(3);
# print get_file_path_by_ver("0","a"),"\n";
# print get_file_path_by_ver("1","a"),"\n";
# print get_file_path_by_ver("2","a"),"\n";
# print get_file_path_by_ver("","a"),"\n";
# print get_track_files(),"\n";
# print file_status(qw("a"));

# print file_status(qw(b));
my @list = qw(heee sass);
delete_value_in_array(@list,"sass");

print @list;


# sub ff {
#   throw  Error("heee");
# }
#
# try {
#   ff;
# }
# catch Error with {
#   my $ex = shift;
# };
