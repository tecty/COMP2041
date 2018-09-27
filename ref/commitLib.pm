#!/usr/bin/env perl
package commitLib;
use warnings;
use strict;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw();

# higer level lib
# add remove commit log actions
1;
