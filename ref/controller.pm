#!/usr/bin/env perl
package controller;
use warnings;
use strict;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_legit );


sub init_legit {
  # create a folder and some routine work

  if (! -d ".legit"  ){
    # print the promt
    print "Initialized empty legit repository in .legit\n";
  }
  else {
    # error occoured
    print STDERR "legit.pl: error: .legit already exists\n";
  }
}


# Highest level lib
1;
