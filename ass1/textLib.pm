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
  # output = src - dest
  my ($src_ref,$dest_ref) = @_;
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
  my @x_keys = sort {$a <=> $b} keys %eq_pos;
  my @y_values = sort {$a <=> $b } values %eq_pos;

  for (my $x = 0; $x < $x_keys[0]; $x++) {
    for (my $y = 0; $y < $y_values[0]; $++) {
      # body...
    }

    $x ++;
  }


  for (my $index = 0; $index < @x_keys; $index++) {
    my $next_x;
    my $next_y;
    if ($index != @x_keys - 1 ){
      # set the next as in array
      $next_x = $x_keys[$index + 1];
      $next_y = $y_values[$index + 1];
    }
    else{
      # set the next as the end of the @src
      $next_x = $#src;
      $next_y = $#dest;
    }
    # fetch the correspond y value
    my $y = $y_values[$index];
    my $x = $x_keys[$index] + 1;
    for (; $x < $next_x; $x ++) {
      # next string will be equal both in y
      if ($y != $next_y ){
        # both add one, and record a change
        # change to the correspond y-index dest value
        $ret{"$x"."C"} = $dest[$y];
        $x ++; $y ++;
      }
      else{
        # remain line as the src's deletion
        $ret{"$x"."D"} ="";
      }
    }

    # remain operation as an add at the last different x-line
    for (; $y < $next_y; $y++) {
      $ret{"$x"."A"} = $dest[$y];
    }
    # exaust of this x and y
  }
  return %ret;
}

sub patch {
  # body...
}



1;
