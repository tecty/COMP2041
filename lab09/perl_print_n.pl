#!/usr/bin/env perl
use warnings;
@lines = ();

# the initial print
$lines[0] = "#!/usr/bin/env perl\n";
$input =~ s/("|\\)/\\$1/g;
$lines[1] = "print \"$input\\n\";\n";



for (my $i = 0; $i < $ARGV[0]-1; $i++) {
  # add the script description
  unshift @lines, "#!/usr/bin/env perl\n";
  for (my $index = 1; $index <= $#lines; $index++) {
    # un specialise the "
    $lines[$index] =~ s/("|\\)/\\$1/g;
    # print the lines
    $lines[$index] =~ s/(.*)/print "$1\\n";/;
  }
}

# echo the wrapped script
print @lines;
