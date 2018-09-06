#!/usr/bin/env perl

%word_array;
while (<STDIN>) {
  # we need to ignore case
  tr/[A-Z]/[a-z]/;
  # fetch all the words in the document
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

# print the  $total_words added
$word_array{$ARGV[0]} = 0 if (! defined $word_array{$ARGV[0]});
print "$ARGV[0] occurred $word_array{$ARGV[0]} times\n";
