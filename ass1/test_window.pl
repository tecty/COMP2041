#!/usr/bin/env perl
use warnings;
use strict;


use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our base lib
use baseLib;

my @array = ("-m","-a","sss");
my $option  =  pop_options(@array);

if( $option =~ /m/){
  print "this arg is true\n";
}

if ($option !~ /k/) {
  print "this is false\n";
}
