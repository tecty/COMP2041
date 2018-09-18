#!/usr/bin/env perl

sub print_line {
  my ($line) =@_;

  print STDOUT "$line\n";
}

sub add_dolar{
  my ($var) = @_;
  if ($var !~ /^\d+$/){
    $var = "\$".$var;
  }
  return $var;
}

foreach (<>) {
  # remove the styleish things
  s/;//;
  chomp ;
  if ($_ eq ""){
    # this line is empty, don't echo this line
    next;
  }

  # ELSE: line is not empty, do the tranlation

  # replace the script hanle function
  s?#!/bin/bash?#!/usr/bin/perl -w?g;


  # replace the "do" and "done" by brackets
  s/^do$/\{/;
  s/^done$/\}/;

  # replace the variable representation
  s/(\w+)=/\$$1 = /;

  if (s/[\$]?\(\((\w+)[ ]?([*\/+-<>=]+)[ ]?(\w+)\)\)//) {
    # replace the operation representation

    # check and add the $ symbol
    $_= $_.add_dolar($1)." $2 ".add_dolar($3); 

  }




  # replace the function operation
  s/echo (.*)/print "$1\\n"/;



  if (s/(while|if|for)(.*)/$1($2)/) {
    # add brackets between the expression
    # just for prettier
    s/\( / (/;
  }
  elsif( /({|}|#)/){
    # do nothing
    # dont add ;
  }
  else{
    # add ; at the end of the line
    $_ = $_.";";
  }

  # print the line out
  print_line $_;
}
