#!/usr/bin/env perl
use warnings;
use strict;

use Error;
# use Text::Diff;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
# include our base lib
use baseLib;
use dbLib;

my %status = file_status(qw(b));
print %status;
