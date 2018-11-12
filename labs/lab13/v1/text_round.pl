#!/usr/bin/env perl 
use warnings; 

while (<>){
	my @number = $_ =~ /[\d\.]?/g;
	print @number,"\n";
	
	#my @text = split /[0-9]+(\.\d*)?/ ,$_;
	#for (my $i=0; $i < $#text; $i += 1 ){
	#	$number[$i] += 0.5;
	#	$text[$i] .= int $number[$i];

		
	#} 
	
	#print @text;
	

}
