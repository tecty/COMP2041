#!/usr/bin/env perl
use warnings;
# store the stdin in to an array
@lines = <STDIN>;

sub print_sorted_words {
  my ($this_line) = @_;
  # match all the words and push it into array
  @words = $this_line =~ /\S+/g;
  # foreach my $word (sort @words) {
  #   print "$word ";
  # }
  # equivelant join and print path
  print join " ", (sort @words);
  print "\n";
}



foreach my $line (@lines) {
  # pass each line to function and print
  print_sorted_words($line);
}
