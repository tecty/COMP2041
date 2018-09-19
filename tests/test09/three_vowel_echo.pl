#!/usr/bin/env perl
use warnings;

# use map as foreach
map { print("$_ ") if $_ =~ /[aeiou]{3,}/i} @ARGV;

# print the end fo the line
print "\n";
