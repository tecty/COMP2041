#!/usr/bin/env perl

use warnings;
use strict;

open my $f, "<",$ARGV[1];
my @content = <$f>;
close $f;

my $readNext = 0;
my $sum = 0;
foreach my $line (reverse @content) {
  if ($readNext == 1) {
    $line =~ /(\d+)/;
    $sum += $1;
  }

  if ($line =~ /$ARGV[0]/ ){ $readNext = 1;}
  else { $readNext =0 ;}
}
print "$sum\n";
