#!/usr/bin/env perl
use warnings;
%lines =();

while (<STDIN>){
  $lines{$_} ++;
}

foreach my $line (sort keys %lines) {
  if ($lines{$line} == $ARGV[0]) {
    print "Snap: $line";
  }
}
