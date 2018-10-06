#!/usr/bin/perl

use warnings;
use strict;

# sort numericly 
@ARGV = sort { int($a) <=> int($b) } @ARGV;

if ($#ARGV %2 == 0 ){
    # array.lenght = odd
    print $ARGV[$#ARGV/2 ];
}
else {
    # array.length = even 
    print (($ARGV[$#ARGV/2 ]+$ARGV[$#ARGV /2 +1])/2);
}


print "\n";