#!/usr/bin/env perl 

# read from stdin
foreach my $line (<STDIN>) {
  $line =~ tr/0-4/</;
  $line =~ tr/5-9/>/;
  print $line;
}


# @lines = <STDIN>;
#
# @lines =~ tr/0-4/</;
# print @lines
