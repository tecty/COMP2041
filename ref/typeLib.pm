#!/usr/bin/env perl
package dbLib;
use warnings;
use strict;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(to_hash uniq delete_value_in_array);

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

sub delete_value_in_array (\@$) {
  my ($arr_ref , $value) = @_;
  for (my $index = 0; $index <= $#$arr_ref; $index++) {
    if ($$arr_ref[$index] eq $value) {
      splice @$arr_ref, $index, 1;
    }
  }
}
