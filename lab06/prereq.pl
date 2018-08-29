#!/usr/bin/env perl

use warnings;

sub find_pre {
  my (@file) = @_;
  # body...
  foreach my $line (@file) {
      # $line =~ s/<.*?>//gi ;
      # $line =~ s/\n//g;
      # $line =~ s/\s//g;
      if ($line =~ /<p>Prerequisite[s]?:(.*?)<\/p>/ ) {
        # body...
        my ($pre)= $1;
        $pre=~ s/^ //g;
        my @courses= ($pre =~ /[A-Z]{4}[0-9]{4}/g);
        foreach my $course (@courses) {
          print "$course\n";
        }
        last;
      }
  }
}


$ug_url = "http://www.handbook.unsw.edu.au/postgraduate/courses/2018/$ARGV[0].html";
$pg_url = "http://www.handbook.unsw.edu.au/undergraduate/courses/2018/$ARGV[0].html";
open UG, "wget -q -O- $ug_url|" or die;
open PG, "wget -q -O- $pg_url|" or die;

find_pre(<UG>);
find_pre(<PG>);
