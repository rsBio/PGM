#!/usr/bin/perl

use strict;
use warnings;

$\ = $/;

my ($i_ilgis, $i_dim) = split ' ', <>;

my @i_dim;
for my $i (1 .. $i_dim){
    push @i_dim, [ split ' ', <> ];
}

my ($j_ilgis, $j_dim) = split ' ', <>;

my @j_dim;
for my $i (1 .. $j_dim){
    push @j_dim, [ split ' ', <> ];
}

## @j_dim = grep /\S/, @j_dim;

#%  print "@{$_}" for @i_dim;
#%  print "@{$_}" for @j_dim;

my @matrix;

for my $i (1 .. $i_ilgis){
    my @line;
    for my $j (1 .. $j_ilgis){
        my $diff;
        for my $r ( 1 .. (sort {$a <=> $b} (0 + @i_dim, 0 + @j_dim) )[0] ){
            $diff += abs( 
                ($i_dim[ $r-1 ][ $i-1 ] // 0)
                - ($j_dim[ $r-1 ][ $j-1 ] // 0)
                );
        #%    print "$i $j :$diff";
        }
        push @line, $diff;
    }
    push @matrix, [ @line ];
}

print join ',', @{$_} for @matrix;
