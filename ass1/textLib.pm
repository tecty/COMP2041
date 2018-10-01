#!/usr/bin/env perl
package textLib;
use warnings;
use strict;
use Exporter;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
use typeLib;
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
  unshift @x_keys, 0;
  unshift @y_values, 0;
  push @x_keys, $#src  +1;
  push @y_values, $#dest +1;

  for (my $index = 0; $index < @x_keys -1; $index++) {
    # fetch this range
    my @range_x = ($x_keys[$index], $x_keys[$index +1]);
    my @range_y = ($y_values[$index], $y_values[$index +1]);

    my $x = $range_x[0];
    my $y = $range_y[0];
    for (; $x < $range_x[1] and $x != $range_x[1] -1 ; $x ++){
      # consume all the common gap
      if ($y == $range_y[1] -1 ){
        # the y is fully consumed, x should be deleted
        $ret{($x+1)."D"} = "";
      }
      else{
        $ret{($x+1)."C"} = $dest[($y+1)];
        $y ++;
      }
    }
    if ($x == $range_x[1]-1 and $y != $range_y[1] -1) {
      # remain line need to convey as x's last line's adds
      $y ++;
      for (; $y < $range_y[1]; $y++) {
        $ret{($x)."A".$y} = $dest[$y];
      }
    }
    elsif($x == $range_x[1]-1 and $y == $range_y[1] -1){
      # luckly, consumed both
    }
    else {
      dd_err("Fatel: I shouldn't be here ");
    }
  }

  # return the file instruction
  return %ret;
}

sub comparte_diff_key {
  $a =~ /([0-9]*)[ADC]([0-9]*)/;
  my $a_line = $1;
  my $a_dest = $2;

  $b =~ /([0-9]*)[ADC]([0-9]*)/;
  my $b_line = $1;
  my $b_dest = $2;
  return ($a_line <=> $b_line or $a_dest <=> $b_dest);
}


sub patch(\@\%) {
  # === construct the dest via diff
  # change ref to actual array and hash table
  my ($src_ref,$diff_ref) = @_;
  my @src = @{$src_ref};
  my %diff = %{$diff_ref};

  # unshift it to have better support at the add at front
  unshift @src,"";

  foreach my $action (reverse sort comparte_diff_key keys %diff) {
    $action =~ /([0-9]*)([ADC])([0-9]*)/;
    my $line = $1;
    my $operation = $2;
    if ($operation eq "D") {
      # use splice to delete that line
      splice @src, $line, 1;
    }
    elsif($operation eq "C") {
      # directly change the content in the line
      $src[$line] = $diff{$action};
    }
    elsif($operation eq "A"){
      # add the line via splice
      # since we do it revertically, we will add 11 then 10 then 9 of dest
      splice @src, $line +1 ,0, $diff{$action};
    }
    else{
      dd_err("Patch Err, I shouldn't be here");
    }
    print "\n==src: $action\n";
    print ">$_\n" for @src;
  }




  # shift it back the empty line
  shift @src;
  return @src;
}



1;
