#!/usr/bin/env perl
package dbLib;
use warnings;
use strict;
use Exporter;

our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_db);


sub create_db {
  my ($db_name) = @_;
  # create the db file
  open my $F, ">", ".legit/__meta__/$db_name";
  close $F;
}


sub init_db {
  # create legit database structure
  if (mkdir ".legit" and mkdir ".legit/__meta__") {
    # init success fully

    # create two db file
    create_db("commit");
    create_db("tracks");
    create_db("branchs");

    return 1;
  }
  # else
  return 0;
}

sub add_key {
  my ($db_name, $key, $value)= @_;

  my %lines;

  # open the file
  open my $F, "<", ".legit/__meta__/$db_name";
  foreach my $line (<F>) {
    # pop the key and remove the sperator 
    $key = $lines =~ /^(.*):/;
    $key = $lines =~ s/://g;

    $lines{} =
  }



}

sub get_key {

}
