#!/usr/bin/perl

use warnings;
use strict;

{ local $/ ; $_ = <> };

$\ = $/;

my( $A, $B ) = split;

my $Hamm = 0;

for my $i ( 0 .. -1 + length $A ){
	$Hamm += 
		( substr $A, $i, 1 ) ne
		( substr $B, $i, 1 )
		;
	}

print $Hamm;
