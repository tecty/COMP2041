#!/usr/bin/env perl

use warnings;

$file=$ARGV[0];

open F, "<" , $file;

# $count = 0;
while ($line = <F>){
  if($line =~ /Orca/i){
    $line =~ /\s(\d+)\s/;
    # print "$1\n";
    $count += $1;
  }
}
print "$count Orcas reported in $file\n";
