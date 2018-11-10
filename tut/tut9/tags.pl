#!/usr/bin/env perl 
use warnings;



if ($ARGV[0] =~ /-f/){
	shift @ARGV;
	$fre = 1;	
}

my $content = `wget -q -O- $ARGV[0]`;
$content =~ tr/A-Z/a-z/;
@tags = $content =~ /<[a-z]*[^>]*>/g;
@tags = grep {! /<\//} @tags;
@tags = grep {! /<!/} @tags;
map {/<([a-z]*)/; $_ = $1} @tags;
my %h;
map {$h{$_}++} @tags;


if ($fre){
	map {print "$_ ", $h{$_}, "\n";} sort {$h{$a} <=> $h{$b}} keys %h;
}
else{

	map {print "$_ ", $h{$_}, "\n";} sort keys %h;
}
