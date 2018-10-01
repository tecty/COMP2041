#!/usr/bin/env perl
package typeLib;
use warnings;
use strict;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(to_hash uniq remove_value_from_array
hashParse hashSerializer
dd_var dd_err dd_arr dd_hash
pop_options is_int
);

sub pop_options(\@) {
  # pop all the option in the array
  my ($arr_ref)= @_;

  # grep all opotions
  my @options = grep {$_ =~ /^-(.*)/ } @$arr_ref;

  # pop all the dash in the array
  @options = grep {$_ =~ s/^-(.*)/$1/g } @options;

  # split all the chars in options and make them unique
  my @options_chars;
  map {push @options_chars, split(//, $_ );} @options;
  uniq(@options_chars);

  # remove all the options in the array
  @$arr_ref = grep { $_ !~ /^-(.*)/ } @$arr_ref;

  # return all the options as a single string
  return join("", @options);;
}

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

sub remove_value_from_array (\@$) {
  my ($arr_ref , $value) = @_;
  for (my $index = 0; $index <= $#$arr_ref; $index++) {
    if ($$arr_ref[$index] eq $value) {
      splice @$arr_ref, $index, 1;
      # move index backward, since the array size is decreased
      $index --;
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

sub is_int {
  return ($_[0] =~ /^([0-9]+)$/);
}


# Debug helper
# dd - die and dump

sub dd_err{
  print STDERR "$_[0]\n";
  exit 1;
}

sub dd_var {
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
