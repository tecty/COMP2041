#!/usr/bin/env perl
package typeLib;
use warnings;
use strict;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(to_hash uniq delete_value_in_array
hashParse hashSerializer
dd_val dd_err dd_arr dd_hash
);

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

sub hashParse{
  # return the hash we want
  my %hash;
  foreach my $line (@_) {
    # remove the new line
    $line=~s/\\n//;
    # split it
    $line =~ /([^:]*):(.*)/;
    # assign the matched key and value
    $hash{$1} = $2;
  }
  return %hash;
}

sub hashSerializer(\%) {
  my ($hash_ref) = @_;
  # store the return value
  my @arr;
  foreach my $key (sort keys %{$hash_ref}) {
    push @arr, "$key:$$hash_ref{$key}\n";
  }
  # return the serialized array
  return @arr
}

sub dd_err{
  print STDERR "$_[0]\n";
  exit 1;
}

sub dd_val {
  print STDERR "> Dump Value:\n";
  if (@_ == 0 or ! defined $_[1]) {
    print STDERR ">> $_[0]\n";
  }
  else {
    print STDERR ">> $_[0]:$_[1]\n";
  }
  exit 1;
}

sub dd_arr {
  print STDERR "> Array ",shift @_,":\n";
  foreach (@_) {
    print STDERR ">> $_\n";
  }
  exit 1;
}

sub dd_hash($\%) {
  print STDERR "> Hash: '$_[0]'\n";
  foreach (hashSerializer(%{$_[1]})) {
    print STDERR ">> $_";
  }
  exit 1;
}

1;
