#!/usr/bin/env perl
package textLib;
use warnings;
use strict;
use Exporter;

our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(is_diff diff patch);


sub is_diff(\@\@) {
  my ($a, $b) = @_;
  if ($#$a != $#$b) {
    # there must be a difference
    return 1;
  }

  for (my $index = 0; $index <= $#$a; $index ++) {
    if ($$a[$index] ne $$b[$index]) {
      # there is an different in this $lines
      return 1;
    }
  }
  return 0;
}



sub diff (\@\@) {
  # we introduce two array to diff
  my ($a, $b) = @_;
  # map {} @$a;
}

sub patch {
  # body...
}



1;
