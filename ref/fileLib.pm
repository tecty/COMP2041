#!/usr/bin/env perl
package fileLib;
use warnings;
use strict;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(get_content get_content touch get_key set_key);

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


sub get_key {
  # create a file to record the current branch
  my @lines = get_content($_[0]);
  # return the first line, since it only has one line
  return $lines[0];
}

sub set_key {
  my ($file, $value) = @_;
  # create a file to record the current branch
  my @arr = ($value);
  # convert this single value to array
  set_content($file,@arr);
}

sub touch {
  # a quick version of map
  map {open my $f,">>",$_; close $f } @_;
}

sub get_meta_path {
  my ($file) = @_;
  if (!(defined $file and $file ne "")) {
    return "./legit/meta/$file";
  }
  return "./legit/meta";
}
