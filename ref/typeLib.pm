#!/usr/bin/env perl
package dbLib;
use warnings;
use strict;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(to_hash uniq);

sub to_hash {
  my %hash;
  # map all the value to hash array
  map {$hash{$_}++} @_;
  return %hash;
}


sub uniq {
  my %seen = to_hash(@_);
  return keys %seen;
}
