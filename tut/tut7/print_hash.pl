#!/usr/bin/env perl
use warnings;

sub print_hash(\%){
	my %h = %{$_[0]};
	map {print "[$_] => $h{$_}\n"} sort keys %{$_[0]};
}

%colours = ("John" => "blue", "Anne" => "red", "Andrew" => "green");
print_hash(%colours);

