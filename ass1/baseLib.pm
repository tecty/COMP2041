#!/usr/bin/env perl
package baseLib;
use warnings;
use strict;
use Exporter;


use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our database lib
use dbLib;


our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(pop_options init_legit);


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

  if (init_db ){
    # print the promt
    print "Initialized empty legit repository in .legit\n";
  }
}


# defualt return mark
1;
