#!/usr/bin/env perl 
use warnings;

$total =0;
while (<>){
    chomp;
    if ($_ =~ '\$(\d+\.\d+)'){
        $total += $1;
    }
}

printf "\$%.2f\n", $total;

