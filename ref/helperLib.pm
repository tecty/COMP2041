#!/usr/bin/env perl
package helperLib;
use warnings;
use strict;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(pop_options);

sub pop_options(\@) {
  # pop all the option in the array
  my ($arr_ref)= @_;

  # grep all opotions
  my @options = grep {$_ =~ /^-(.*)/ } @$arr_ref;

  # pop all the dash in the array
  @options = grep {$_ =~ s/^-(.*)/$1/g } @options;

  # remove all the options in the array
  @$arr_ref = grep { $_ !~ /^-(.*)/ } @$arr_ref;

  # return all the options as a single string
  return join("", @options);;
}


1;
