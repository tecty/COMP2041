#!/usr/bin/env perl
use warnings;
use strict;


use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our base lib
use Base_lib;

my @array = ("-m","-a","sss");
print pop_options(@array);
print "\n";
print @array;
