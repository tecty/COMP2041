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
