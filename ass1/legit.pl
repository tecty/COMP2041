#!/usr/bin/env perl
use warnings;
use strict;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# import all
use branchLib;
use controller;
use fileLib;
use helperLib;
use typeLib;

# holding for main function
sub show_usage {
  # print the error message
  print "Usage: legit.pl <command> [<args>]

These are the legit commands:
 init       Create an empty legit repository
 add        Add file contents to the index
 commit     Record changes to the repository
 log        Show commit log
 show       Show file at particular state
 rm         Remove files from the current directory and from the index
 status     Show the status of files in the current directory, index, and repository
 branch     list, create or delete a branch
 checkout   Switch branches or restore current directory files
 merge      Join two development histories together\n\n";
  exit 1;
}


sub main {
  # a big switch to dispatch to inter function
  # dispatch by command line args


  if ($#ARGV == -1) {
    show_usage();
  }

  # shift out the first word as sub command
  my $command = shift @ARGV;

  if ($command eq "init") {
    # call the init function
    init_legit(@ARGV);
    # break the rest of match
    exit 0;
  }
  if (! -d ".legit"){
    # not exist error abort all the actions
    print STDERR "legit.pl: error: no .legit directory containing legit repository exists\n";
    exit 1;
  }
  if($command eq "add"){
    # add the files to working directory
    dd_err("usage: legit.pl add <filenames>") if ! add(@ARGV);
    exit 0;
  }
  elsif($command eq "commit"){
    dd_err("usage: legit.pl commit [-a] -m commit-message") if ! commit(@ARGV);
    exit 0;
  }
  elsif($command eq "log"){
    show_log();
    exit 0;
  }

  # remainning action need to have at least one commit
  if (get_max_commit() == -1) {
    dd_err("legit.pl: error: your repository does not have any commits yet");
  }

  if($command eq "show"){
    dd_err("usage: legit.pl show <commit>:<filename>") if ! show(@ARGV);
  }
  elsif($command eq "rm"){
    dd_err("usage: legit.pl rm [--force] [--cached] <filenames>")
      if ! remove(@ARGV);
  }
  elsif($command eq "status"){
    show_status();
  }
  elsif($command eq "branch"){
    dd_err("usage: legit.pl branch [-d] <branch>") if ! branch(@ARGV);
  }
  elsif($command eq "checkout"){
    dd_err("usage: legit.pl checkout <branch>") if ! checkout(@ARGV);
  }
  elsif($command eq "merge"){
  }
  else{
    print STDERR "legit.pl: error: unknown command $command\n";
    show_usage();
    exit 1;
  }
}

main();
