#!/usr/bin/env perl

# use warnings;

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

# get the log probrobility of a word
sub get_log_pro {
  my ($word, $file_name) = @_ ;
  return log(($word_array{$file_name}{$word}+1)/$total_words{$file_name});
}

sub find_singer_by_song_name{
  my ($song_name) = @_;

  # sum of probrobility of each artist
  my %probrobility;

  # open the song file
  open F,"<", $song_name;

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

      # plus the log probrobility
      foreach my $artist_file_name (sort keys %word_array) {
        # push this probrobility to the hash table
        $probrobility{$artist_file_name} +=
          get_log_pro($word, $artist_file_name);
      }
    }
  }

  # sort probrobility by desc order

  foreach my $key (
    reverse sort { $probrobility{$a} <=>  $probrobility{$b} } keys %probrobility
  ) {
    # print the higest probrobility artist
    printf (
      "%s most resembles the work of %s (log-probability=%3.1f)\n",
      $song_name,
      get_artist_name($key),
      $probrobility{$key}
    );
    # and break
    last;
  }



  # close the opened file
  close F;
}


# fetch the original data fron the files
foreach $file (glob "lyrics/*.txt") {
  count_word_in_file($file);
}

# fetch all the song's name
for (my $index = 0; $index < @ARGV; $index++) {
  find_singer_by_song_name($ARGV[$index]);
}





# print the  $total_words added
# foreach my $file_name (sort keys %word_array) {
#   printf("log((%d+1)/%6d) = %8.4f %s\n",  $word_array{$file_name}{$ARGV[0]},
#     $total_words{$file_name},
#     get_log_pro($ARGV[0],$file_name),
#     get_artist_name($file_name) )
# }
