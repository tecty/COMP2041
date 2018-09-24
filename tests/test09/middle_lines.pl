#!/usr/bin/env perl
use warnings;
use strict;

my @lines = <>;

if ($#lines == -1 ) {
  # do nothing
}
else{
  # even line numbers
  print $lines[$#lines /2];
  # print onemore line if it's even line number
  print $lines[$#lines /2+1] if $#lines %2 == 1;
}
