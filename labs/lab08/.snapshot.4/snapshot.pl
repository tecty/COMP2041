#!/usr/bin/env perl
use warnings;
use strict;
use File::Copy;
use File::Glob;

# return the snapshot directory name for version specified
sub gen_snap_dir {
  # the version specify
  my ($ver) =@_;
  return ".snapshot.$ver";
}

sub pop_snap_dir_from_name {
  my ($file) = @_;

  $file =~ s/.snapshot.[0-9]+\///g;
  return $file;
}


sub create_snapshot {
  # list all the normal files
  my @files = glob("*");
  # remove this file from tracking
  @files = grep { $_ ne $0 } @files;

  # counter of howmany snapshot
  my $i = 0;
  my $snap_dir = gen_snap_dir($i);

  while (-d $snap_dir ) {
    $i ++;
    # reconstrcut the directory name
    $snap_dir = gen_snap_dir($i);
  }
  # we got the directory we want
  # make this snapshot
  mkdir $snap_dir;
  # print the message
  print "Creating snapshot $i\n";

  # copy all the file into this snapshot
  # use map instead of while,
  map {copy($_, "$snap_dir/$_") } @files;
}

# pop the command word from cmd
my $command = shift @ARGV;

if( $command eq "save"){
  create_snapshot();
}
elsif( $command eq "load"){
  create_snapshot();

  # pop the version
  my $snap_ver = shift @ARGV;

  # list all the normal files
  my @files = glob(gen_snap_dir($snap_ver)."*");
  # remove this file from tracking
  @files = grep { $_ ne $0 } @files;
  # remove all the file in pwd
  unlink @files;

  # copy all the files from snapshot
  # use map instead of while,
  map {copy($_, pop_snap_dir_from_name($_)) } @files;

  # print the message
  print "Restoring snapshot $snap_ver\n";
}
