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

sub process_test {
  my ( $test_parms )=  @_;
  # print( "imhere");

  my @params = $test_parms  =~ /(\w+|[*\/+-<>=!%]+)/g;
  # init a empty string for returned value
  my $ret = "";

  foreach my $param (@params) {
    if ($param =~ /^\w+$/) {
      # this is an arg name
      $ret .= add_dolar($param);
    } elsif ($param =~ /[*\/+-<>=!%]+/) {
      # this is an operation
      # pass and add indent
      $ret .= " $param ";
    }
  }

  # return the processed expression
  return $ret
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
  s/(done|fi)/\}/;
  s/(do|then)/\{/;

  # replace else as }{ since else will alway has another sections of codes
  s/else/\} else \{/;

  # process elif replacement
  s/elif(.*)/} elsif $1 \{/;




  # replace the variable representation
  s/(\w+)=/\$$1 = /;


  if (s/\$?\(\(([^)]*)\)\)//) {
    # replace the operation representation

    # check and add the $ symbol
    $_= $_.process_test($1);

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
