#!/usr/bin/perl -w

# Initial how much line will be print
$linePrint = 10;

foreach $arg (@ARGV) {
    if ($arg eq "--version") {
        print "$0: version 0.1\n";
        exit 0;
    }
    # handle other options
    elsif ($arg =~ /^-[0-9]+$/) {

      # fetch the number and assign
      $arg =~ s/\-//;
      $linePrint = $arg;
    }
    else {
        push @files, $arg;
    }
}



foreach $file (@files) {
    open F, '<', $file or die "$0: Can't open $file: $!\n";

    # process F
    @lines = <F>;

    if ($#files >=1) {
      # more than two files print the filenames
      print "==> $file <==\n";
    }


    if ($#lines < $linePrint ) {
      # prevent index over bound
      print @lines;
    } else {
      print @lines[-$linePrint..-1];
    }

    close F;
}
