#!/usr/bin/env perl
use warnings;
%words = ();
while ($_ = shift @ARGV){
  if (! exists $words{$_}){
    print "$_ ";
    $words{$_} = 1;
  }
}

print "\n";
