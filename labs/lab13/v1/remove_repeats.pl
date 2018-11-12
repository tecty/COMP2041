#!/usr/bin/env perl 
use warnings; 

my %h;
map {$h{$_}= 1 } @ARGV;

map { 
	if ($h{$_} == 1){
		print "$_ "; 
		$h{$_}= 0;
	}
} @ARGV;

print "\n";
