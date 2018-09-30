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

sub max_two {
  # simple way to find max in two number
  my ($a, $b) = @_;
  return ($a > $b) ? $a : $b;
}


sub diff (\@\@) {
  # we introduce two array to diff
  # using LCS algorithm
  # output = dest - ref
  my ($dest_ref ,$src_ref) = @_;
  # create an array of content inputed, in this way, we can prevent the
  # source array wouldn't be change
  my @src = @$src_ref;
  my @dest = @$dest_ref;

  # unshift it to have better calculation property
  unshift @src, "";
  unshift @dest, "";

  # array of the algorithm's output
  my @lcs_array;
  # init the array
  for (my $x = 0; $x < @src; $x++) {
    for (my $y = 0; $y < @dest; $y++) {
      $lcs_array[$x][$y] = 0;
    }
  }


  # first row and column is 0 as required
  for (my $x = 1; $x < @src; $x++) {
    for (my $y = 1; $y < @dest; $y++) {
      if ($src[$x] eq $dest[$y]) {
        # according to algo, arr[x][y] = arr[x-1][y-1]+1
        $lcs_array[$x][$y] =$lcs_array[$x-1][$y-1] +1;
      }
      else{
        $lcs_array[$x][$y] = max_two($lcs_array[$x - 1][$y], $lcs_array[$x][$y-1]);
      }
    }
  }

  # record the position of same string, which construct the lcs
  my %eq_pos;
  # travelback the array
  my $x = @src -1;
  my $y = @dest -1;
  while ($lcs_array[$x][$y] != 0){
    if ($lcs_array[$x][$y-1] == $lcs_array[$x][$y] ) {
      # move up because this direction is approved
      $y = $y -1;
    }
    elsif ($lcs_array[$x-1][$y] == $lcs_array[$x][$y]){
      $x = $x -1;
    }
    else{
      # both direction is block ==> this location has both sting is equal
      $eq_pos{$x} = $y;
      # move left and up
      $x = $x-1; $y = $y -1;
    }
  }


  # return the operation to construct the dest
  # ret = dest - src;
  my %ret;


  return %eq_pos;
}

sub patch {
  # body...
}



1;
