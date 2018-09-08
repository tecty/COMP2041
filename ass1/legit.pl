#!/usr/bin/env perl
use warnings;
use strict;


use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our base lib
use Base_lib;



sub dispatch {
  # a big switch to dispatch to inter function
  # dispatch by command line args


  if ($#ARGV + 1 == 0) {
    # print the error message
    print "Usage: $0 [commands]\n";
    exit 1;
  }


  # shift out the first word as sub command
  my $command = shift @ARGV;

  if ($command eq "init") {
    # call the init function
    init_legit(@ARGV);
  }
}

dispatch();
