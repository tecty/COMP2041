#!/usr/bin/env perl

use warnings;

sub find_pre {
  my (@file) = @_;
  # body...
  foreach my $line (@file) {
      if ($line =~ /<p>Prerequisite[s]?:(.*?)<\/p>/ ) {
        # body...
        my ($pre)= $1;
        $pre=~ s/^ //g;
        my @courses= ($pre =~ /[A-Z]{4}[0-9]{4}/g);
        # foreach my $course (@courses) {
        #   print "$course\n";
        # }
        # print @courses;
        return @courses;
      }
  }
}


$ug_url = "http://www.handbook.unsw.edu.au/postgraduate/courses/2018/$ARGV[0].html";
$pg_url = "http://www.handbook.unsw.edu.au/undergraduate/courses/2018/$ARGV[0].html";
open UG, "wget -q -O- $ug_url|" or die;
open PG, "wget -q -O- $pg_url|" or die;

push @courses , find_pre(<UG>);
push @courses , find_pre(<PG>);

foreach my $course (sort @courses) {
  if ($course eq "") {
    # don't print this line
    next;
  }

  print "$course\n";
}
