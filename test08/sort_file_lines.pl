#!/usr/bin/env perl
use warnings;

@lines = <>;

@lines = sort @lines;
@lines = sort {length($a) <=> length($b)} @lines;

print @lines;
