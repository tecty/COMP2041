#!/usr/bin/env perl
package fileLib;
use warnings;
use strict;
use FindBin;
use File::Spec;
# add current directory on the fly
use lib File::Spec->catfile($FindBin::Bin);
#  this file need to use all our basic lib except this one
use typeLib;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(get_content set_content touch get_key set_key
get_meta_path
get_hash_from_file add_hash_to_file delete_hash_from_file set_hash_to_file
);

sub get_content {
  # a helper function only read the whole file
  my ($file) = @_;
  open my $f, "<",$file or dd_var("File Path on get_conent", $file);
  my @content = <$f>;
  close $f;
  return @content;
}

sub set_content($\@) {
  # helper function to write the whole file
  my ($file, $content_ref) = @_;
  open my $f, ">", $file or dd_var("File Path on set_content", $file);
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
  if (defined $file and $file ne "") {
    return ".legit/meta/$file";
  }
  return ".legit/meta";
}

# CRUD of a Hash File

sub get_hash_from_file{
  my ($file)=  @_;
  my @content = get_content($file);
  # parse the read conetnt
  return hashParse(@content);
}

sub set_hash_to_file($\%) {
  my ($file, $hash_ref) = @_;
  # write back the content to the file;
  my @content = hashSerializer(%{$hash_ref});
  set_content($file, @content);
}

sub add_hash_to_file($\%) {
  my ($file, $hash_ref) = @_;
  my %hash = get_hash_from_file($file);
  foreach (keys %{$hash_ref}) {
    # append the hash content to this hash
    $hash{$_} = $$hash_ref{$_};
  }
  # write back the content to the file;
  set_hash_to_file($file, %hash);
}

sub delete_hash_from_file {
  my ($file, @keys) = @_;
  my %hash = get_hash_from_file($file);
  # remove all the keys need to delete
  map {delete $hash{$_}} @keys;
  # set the hash content to the file;
  my @content = hashSerializer(%hash);
  set_content($file, @content);
}



1;
