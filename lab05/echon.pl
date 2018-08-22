#!/usr/bin/env perl

if ($#ARGV != 1 ) {
  # print the basic usage
  print "Usage: $0 <number of lines> <string>\n";
}
# else, check type
if($ARGV[0] < 0){
  print "$1: argument 1 must be a non-negative integer\n";
}

# print $#ARGV;
for (my $i = 0; $i < $ARGV[0]; $i++) {
  print "@ARGV[1]\n";
}
