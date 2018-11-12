#!/usr/bin/env perl 
use warnings; 


@content = <>;

my $flag = 1;
while ($flag) {
	$flag = 0;
	map {
	    if ($_ =~ /#(\d+)/){
	        $_ = $content[$1-1]; $flag = 1;
	    } 
    } @content;

}


print @content;
