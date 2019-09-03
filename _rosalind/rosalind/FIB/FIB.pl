#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

while( <> ){
	
	my( $n, $k ) = split;
	
	my( $A, $B ) = ( 1, 1 );
	
	for my $i ( 2 .. $n ){
		( $A, $B ) = ( $B, $A * $k + $B );
		}
	
	print $A;
	}