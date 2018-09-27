#!/usr/bin/env perl
package dbLib;
use warnings;
use strict;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(get_content get_content touch);

sub get_content {
  # a helper function only read the whole file
  my ($file) = @_;
  open my $f, "<",$file;
  my @content = <$f>;
  close $f;
  return @content;
}

sub set_content($\@) {
  # helper function to write the whole file
  my ($file, $content_ref) = @_;
  open my $f, ">", $file;
  print $f @$content_ref;
  close $f;
}

sub touch {
  # a quick version of map
  map {open my $f,">>",$_; close $f } @_;
}
