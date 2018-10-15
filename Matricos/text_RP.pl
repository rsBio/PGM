#!/usr/bin/perl

use strict;
use warnings;
use utf8;

$\ = $/;

my @data = map lc, split ' ', ( join '', <> ) =~ s/\W/ /gr;

#%	print "[@data]";

my @matrix;

for my $i ( 0 .. @data - 1 ){
    my @line;
    for my $j ( 0 .. @data - 1 ){
        my $diff;
        my $L = $data[ $i ];
        $L =~ s/...\K.*//;
        my $R= $data[ $j ];
        $R =~ s/...\K.*//;
        
        $diff = 0 + ( $L eq $R );
        push @line, $diff;
    }
    push @matrix, [ @line ];
}

print join ' ', @{$_} for @matrix;
