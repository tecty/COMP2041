#!/usr/bin/env perl

%word_array;
while (<STDIN>) {
  @words = $_ =~ /([a-zA-Z]*)/g;
  # print $_;
  foreach my $word (@words) {
    if ($word eq "") {
      # ignore the didn't match words
      next;
    }
    $word_array{$word} ++;
    # print "'$word'\n";
  }
}

# counter for all the words
$total_words = 0;

foreach my $key (sort keys %word_array) {
  # print "$key occour $word_array{$key}\n"
  $total_words += $word_array{$key};
}

# print the  $total_words added
print "$total_words words\n";
