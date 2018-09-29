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
# this script for testing
my %hash;
$hash{0}= "-1";
$hash{1}= "0";
$hash{2}= "1,0";
$hash{3}= "2";
$hash{4}= "3";
$hash{5} = undef;

my %status = file_status(qw(a));
dd_hash("status", %status);
