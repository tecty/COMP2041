#!/usr/bin/perl -w
$i = 0;

my %lines;
foreach my $line (<STDIN>) {
  # body...
  $lines{$i} = $line;
  $i ++;
}
print  values %lines
