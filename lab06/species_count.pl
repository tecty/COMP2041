#!/usr/bin/env perl

use warnings;
$specie = $ARGV[0];
$file = $ARGV[1];

# open the file
open F ,"<" , $file;

while ($line = <F>){
  # fetch the specie
  if($line =~ /$specie/i){
    $line =~ /\s(\d+)\s/;
    # print "$1\n";
    $count += $1;
    $podCount++;
  }
}

print "$specie observations: $podCount pods, $count individuals\n";

# print <F>;
