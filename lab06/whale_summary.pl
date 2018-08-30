#!/usr/bin/env perl

use warnings;

$file = $ARGV[0];
# open the file
open F ,"<" , $file;

while ($line = <F>){
	#print $line;
  # fetch the specie
  if($line =~ /([\D ]+)$/i){

    $whale_specie = $1;
    # remove the head and tail ch we doesn't want
    $whale_specie =~ s/\n//g;
    # remove messey space we doesn't want
    $whale_specie =~ s/[ ]+/ /g;

    $whale_specie =~ s/^ //g;
    $whale_specie =~ s/ $//g;
    $whale_specie =~ s/s$//ig;
    $whale_specie = lc $whale_specie;
    # print "$whale_specie\n";

    # print "$whale_specie\n";
  	$podCount{$whale_specie} ++;
    # fetch the the numbers of the identify observations
    $line =~ /\s(\d+)\s/;
    $count{$whale_specie} += $1;
  }
}

# print "\n";

foreach $key (sort keys %count){
  print "$key observations: $podCount{$key} pods, $count{$key} individuals\n";
}
