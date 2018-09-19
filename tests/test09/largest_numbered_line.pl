#!/usr/bin/env perl
use warnings;
use List::Util qw(reduce max);

sub get_max_from_line {
  my ($in) = @_;
  my @out = $in=~ /(-?[0-9]*.?[0-9]+)/;

  # only max when there is a number
  return max(@out)  if @out != 0;
}

my @lines = <>;

my $max_line = reduce {
  get_max_from_line($a)> get_max_from_line($b) ? $a:$b
} @lines;

# fetch the $max_num
$max_num  = get_max_from_line($max_line);

if ($max_num ne ""){
  # only try to fetch the largest number's line when it has fetched a number

  foreach my $line (@lines) {
    print $line if $line =~ /$max_num/;
  }
}
