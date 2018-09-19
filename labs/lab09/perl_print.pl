#!/usr/bin/env perl
print "#!/usr/bin/env perl\n";

$input = $ARGV[0];
$input =~ s/("|\\)/\\$1/g;
# normalise the newline 
$input =~ s/\n/\\n/g;
print "print \"$input\\n\";\n";
