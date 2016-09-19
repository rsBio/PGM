#!/usr/bin/perl

use strict;
use warnings;

$\ = $/;

my ($ilgis, $dim) = split ' ', <>;

my @i_dim = map { [split] } grep m/\S/, <>;

#%  print "@{$_}" for @i_dim;
my @matrix;

for my $i (1 .. $ilgis){
    my @line;
    for my $j (1 .. $ilgis){
        my $diff;
        for my $r (@i_dim){
            $diff += abs( $r->[ $i-1 ] - $r->[ $j-1 ] );
        #%    print "$i $j :$diff";
        }
        push @line, $diff;
    }
    push @matrix, [ @line ];
}

print join ',', @{$_} for @matrix;
