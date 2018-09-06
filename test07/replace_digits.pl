#!/usr/bin/env perl
use warnings;

# read the file specify by user
open IN, "<", $ARGV[0];
@lines = <IN>;
close IN;

# reopen the file for dump the result
open OUT, ">", $ARGV[0];
foreach my $line (@lines) {
  # replace the digit
  $line  =~ tr /0-9/#/;
  # dmup the result
  print OUT $line;
}


# close the file and die
close OUT;
