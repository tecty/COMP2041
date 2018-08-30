#!/usr/bin/env perl

use warnings;

$root_course = $ARGV[0];

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
          if (! exists $visited{$course} && ! exists $unvisited{$course} ) {
            # this course need to be visited, push to the list
            push @unvisited ,$course;
          }

        }
        last;
      }
  }
}

sub visit_course {
  push @unvisited, $ARGV[0];

  # use a queue to check which course we need to visit 
  while (@unvisited) {
    $course = shift @unvisited;

    # this course will be visited
    $visited{$course}  = 1;

    $ug_url = "http://www.handbook.unsw.edu.au/postgraduate/courses/2018/$course.html";
    $pg_url = "http://www.handbook.unsw.edu.au/undergraduate/courses/2018/$course.html";
    open UG, "wget -q -O- $ug_url|" or die;
    open PG, "wget -q -O- $pg_url|" or die;

    find_pre(<UG>);
    find_pre(<PG>);
    # close those files
    close UG;
    close PG;
  }


  $unvisited{$course}  = 1;
}


visit_course($ARGV[0]);

foreach my $key (sort keys %visited) {
  if ($root_course ne  $key ) {
    print "$key\n";
  }

}
