#!/usr/bin/env perl
use warnings;
use strict;
use File::Copy;
use File::Glob;

my $command = shift @ARGV;

sub create_snapshot {
  # list all the normal files
  my @files = glob("*");
  # remove this file from tracking
  @files = grep { $_ ne $0 } @files;

  # counter of howmany snapshot
  my $i = 0;
  my $snap_dir = ".snapshot.$i";

  while (-d $snap_dir ) {
    $i ++;
    # reconstrcut the directory name
    $snap_dir = ".snapshot.$i";
  }
  # we got the directory we want
  # make this snapshot
  mkdir $snap_dir;
  # print the message
  print "Creating snapshot $i";

  # copy all the file into this snapshot
  # use map instead of while,
  map {copy($_, "$snap_dir/$_") } @files;
}



if( $command eq "save"){
  create_snapshot();
}
elsif( $command eq "load"){
  create_snapshot();
}
