#!/usr/bin/env perl
use warnings;
use strict;
use File::Copy;


# the counter of the version
my $i = 0;
# the backup file name
my $back = ".$ARGV[0].$i";
while (-e $back) {
  $i ++;
  # reconstrcut the backup file name
  $back = ".$ARGV[0].$i";
}

copy("$ARGV[0]","$back");
