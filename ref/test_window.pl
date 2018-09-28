#!/usr/bin/env perl
use warnings;
use strict;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# import all
use branchLib;
use commitLib;
use controller;
use fileLib;
use helperLib;
use typeLib;
# this script for testing
my %hash;
$hash{1}= "a";
$hash{2}= "b";
$hash{3}= "c";
$hash{4}= "d";

# dd_hash("hash",%hash);
my @arr  = hashSerializer(%hash);
%hash =  hashParse(@arr);
dd_hash("array to hash",%hash);
