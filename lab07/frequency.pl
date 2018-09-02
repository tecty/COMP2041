#!/usr/bin/env perl

use warnings;

our %word_array;
our %total_words;
sub count_word_in_file {
  my ($file_name) = @_;

  open F, "<" , $file_name;

  # open the file
  while (<F>) {
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
      $word_array{$file_name}{$word} ++;
      # print "'$word'\n";
    }
  }

  # close the file
  close F;

  # count the total words for each artist
  foreach my $key (sort keys %{$word_array{$file_name}}) {
    # add all the words of this
    $total_words{$file_name} += $word_array{$file_name}{$key};
  }
}

# function to get the name of artist
sub get_artist_name {
  my ($artist) = @_;

  # pop the folder name out
  $artist =~ s/^lyrics\///;
  # pop the file type out
  $artist =~ s/.txt$//;
  # remove the "_"
  $artist =~ s/_/ /g;

  # return the artist name
  return $artist;
}


foreach $file (glob "lyrics/*.txt") {
  count_word_in_file($file);
}

# print the  $total_words added
foreach my $file_name (sort keys %word_array) {
  printf("%4d/%6d = %.9f %s\n",  $word_array{$file_name}{$ARGV[0]},
    $total_words{$file_name},
    $word_array{$file_name}{$ARGV[0]}/$total_words{$file_name},
    get_artist_name($file_name));
}
