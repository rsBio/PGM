#!/usr/bin/perl

use warnings;
use strict;
use bigint;

$\ = $/;

<>;

{ local $/ ; $_ = <> };

s/\s//g;

my $A = () = m/A/g;
my $U = () = m/U/g;
my $C = () = m/C/g;
my $G = () = m/G/g;


print eval join '*',
map { my( $less, $more ) = sort { $a <=> $b } @{ $_ };
	( reverse 1 .. $more )[ 0 .. $less - 1 ];
	} 
	[ $A, $U ], [ $C, $G ];
