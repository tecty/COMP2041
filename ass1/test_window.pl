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

use File::Path 'rmtree';

print join ("\n",glob(".legit/__meta__/*")),"\n";
