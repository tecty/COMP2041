#!/usr/bin/env perl
package Base_lib;
use warnings;
use strict;
use Exporter;


our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw( init_legit commit pop_options);


sub pop_options(\@) {
  # pop all the option in the array
  my ($arr_ref)= @_;

  # grep all opotions
  my @options = grep {$_ =~ /^-(.*)/ } @$arr_ref;

  # pop all the dash in the array
  @options = grep {$_ =~ s/^-(.*)/$1/g } @options;

  # remove all the options in the array
  @$arr_ref = grep { $_ !~ /^-(.*)/ } @$arr_ref;

  # return all the options as a single string
  return join("", @options);;
}



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

sub commit {
  my @list_arg=@_;



}
