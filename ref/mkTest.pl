#!/usr/bin/env perl
use File::Copy;
@tests = glob("myTest/*.sh");

$index = 0 ;
map {
  $test_name = sprintf ("test%02d.sh", $index);
  copy($_,$test_name);
  $index ++;
}@tests;
