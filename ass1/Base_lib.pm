#!/usr/bin/env perl
package Base_lib;
use warnings;
use strict;
use Exporter;


our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw( init_legit );


sub init_legit {
  # create a folder and some routine work

  # create a folder
  if (mkdir ".legit" ) {
    # init success fully 
    open my $F, ">", ".legit/history";
    close $F;

    # print the promt
    print "Initialized empty legit repository in .legit\n";
  }





}

1;
