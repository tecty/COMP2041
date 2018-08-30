#!/usr/bin/env perl

use warnings;
use strict;


open F, '>', $ARGV[2];
our $min = $ARGV[0];
our $max = $ARGV[1];

for (my $count = $min; $count <=$max; $count++) {
  print F "$count\n";
}
