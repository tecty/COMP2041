#!/usr/bin/env perl

use warnings;


open F ,"<", $ARGV[1] or die;

@lines = <F>;

if (0<=$ARGV[0]-1 && $ARGV[0]-1<= $#lines){
  print $lines[$ARGV[0]-1];
}
