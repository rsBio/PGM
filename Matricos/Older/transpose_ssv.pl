#!/usr/bin/perl

use strict;
use warnings;

$\ = $/;

my @data;

for (<>){
    my $i = 0;
    for (split){
        push @{$data[ $i++ ]}, $_;
    }
}

print join ' ', @{$_} for @data;
