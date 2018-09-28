#!/usr/bin/env perl
package controller;
use warnings;
use strict;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
#  this file need to use all our basic lib except this one
use branchLib;
use fileLib;
use helperLib;
use typeLib;

our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_legit add);


sub init_legit {
  # create a folder and some routine work

  if (! -d ".legit" and init_db() ){
    # print the promt
    print "Initialized empty legit repository in .legit\n";
  }
  else {
    # error occoured
    dd_err("legit.pl: error: .legit already exists");
  }
}

sub add {
  # pop all the actions, hence it would only contain the files
  pop_options(@_);
  add_files (@_);
}
# Highest level lib
1;
