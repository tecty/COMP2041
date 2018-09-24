#!/usr/bin/env perl
use warnings;
use strict;


use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our base lib
use baseLib;

#
# Required the actions
#

sub commit {
  my @list_arg=@_;

  # pop all the options
  my $options = pop_options(@list_arg);

  if ($options =~ /m/ ) {

  }
}

sub add {
  # pop all the actions, hence it would only contain the files
  pop_options(@_);
  add_files @_;
}


sub main {
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
  elsif($command eq "add"){
    # add the files to working directory
    add(@ARGV);
  }
  elsif($command eq "commit"){
    # parse the command line arguments
    my $options = pop_options(@ARGV);
    my $commit = join " ",@ARGV;
    if ($options =~ /a/){
      # fetch all the tracked file
      my @files = get_track_files();
      add_files(@files);
    }
    if ($options =~ /m/){
      # commit as message
      commit_files($commit);
    }

  }
  elsif($command eq "log"){
    show_log();
  }
  elsif($command eq "show"){
    show_file_by_ver(@ARGV);
  }
  elsif($command eq "rm"){
    # we can only handle the show args, we replace them
    my @args = map {$_ =~ s/--force/-f/g; $_ =! s/--cached/-c/g} @ARGV;
    # we loved option list
    my $options = pop_options(@args);
    if ($options !~ /c/ ) {
      # remove the current directory's file
      unlink @args;
    }
    else{
      
    }



  }
}

main();
