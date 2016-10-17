#!/usr/bin/perl

use strict;
use warnings;

$\ = $/;

my ($ilgis, $dim) = split ' ', <>;

my @i_dim = map { [split] } grep m/\S/, <>;

#%  print "@{$_}" for @i_dim;

my @Nb;

for my $i (1 .. $ilgis){
    my $sum;
    for my $j (1 .. $dim){
        $sum += $i_dim[ $j-1 ][ $i-1 ];
    #%    print "  $i $j: $sum";
    }
    push @Nb, $sum;
}

#%  print "@Nb";

my @lambda;

for my $i (1 .. $ilgis){
    my $sum;
    for my $j (1 .. $dim){
        $sum += ( $i_dim[ $j-1 ][ $i-1 ] / $Nb[ $i-1 ] ) ** 2;
    #%    print "  $i $j: $sum";
    }
#%    printf "    lambda b[%d]: %s\n", $i, $sum;
    push @lambda, $sum;
}

#%  print "@lambda";

my @matrix;

for my $i (1 .. $ilgis){
    my @line;
    for my $j (1 .. $ilgis){
        my $sum;
        for my $r (@i_dim){
            $sum += $r->[ $i-1 ] * $r->[ $j-1 ];
        #%    print "$i $j :$C";
        }
        push @line, 2 * $sum / 
            ( ($lambda[ $i-1 ] + $lambda[ $j-1 ]) * $Nb[ $i-1 ] * $Nb[ $j-1 ] );
    }
    push @matrix, [ @line ];
}

print join ',', @{$_} for @matrix;
