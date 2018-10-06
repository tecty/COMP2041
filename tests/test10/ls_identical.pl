#!/usr/bin/perl

use warnings;
use strict;

my @a_files = glob($ARGV[0]."/*");
# my @b_files = glob($ARGV[1]."/*");

my @same_files;

sub is_same{
    my ($a, $b) = @_;
    open my $f, "<", $a;
    my @a_content = <$f>;
    close $f;
    open  $f, "<", $b;
    my @b_content = <$f>;
    close $f;
    # lines count is not same => content is not same
    return 0 if @a_content != @b_content; 

    foreach (my $i = 0 ; $i < @a_content; $i++){
        return 0 if($a_content[$i] ne $b_content[$i]);
    }

    # checked all the lines => all content is same;
    return 1;
}

foreach my $a_file (@a_files) {
    # processing the filename to be another diectory 
    my $bare_file = $a_file;
    $bare_file =~ s?$ARGV[0]/??;
    my $b_file = "$ARGV[1]/".$bare_file;
    if (-f $b_file){
        if(is_same($a_file,$b_file)){
            push @same_files, $bare_file;
        }
    }
}

@same_files = sort @same_files;

print join("\n", @same_files),"\n";