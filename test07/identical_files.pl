#!/usr/bin/env perl
#use warnings;

sub max {
  my ($x, $y) = @_;
  $x >= $y ? return $x : return $y;
}


if ($#ARGV <1){
  # no supplied enough arguments die
  print "Usage: $0 <files>\n";
  exit 1;
}

# open the first file as @template
open F, "<", $ARGV[0];
@template = <F>;
close F;

# remove the first file
# because it is store at @template
shift @ARGV;

foreach my $file (@ARGV) {
  # open the file that need to compare
  open F, "<", $file;
  @compare = <F>;
  close F;

  # compare
  for (my $index = 0; $index < max ($#compare, $#template); $index++) {
    if( $compare[$index] ne $template[$index]){
      # a file is not identical, break the programme
      print "$file is not identical\n";
      exit 2;
    }
  }
}


# all files ar identical
print "All files are identical\n";
