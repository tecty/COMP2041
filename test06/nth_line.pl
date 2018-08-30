#!/usr/bin/env perl

use warnings;


open F ,"<", $ARGV[1];

@lines = <F>;

if (0<=$ARGV[0]-1 && $ARGV[0]-1<= $#lines+1){
  print $lines[$ARGV[0]-1];
}
