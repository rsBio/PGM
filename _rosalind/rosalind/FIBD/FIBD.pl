#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

while( <> ){
	
	my( $n, $m ) = split;
	
	my @fib = ( 1, 1 );
	
	for my $i ( 2 .. $n - 1 ){
		push @fib, $fib[ @fib - 2 ] + $fib[ @fib - 1 ] 
			- ( $i - 0 < $m ? 0 : $i - 0 == $m ? 1 : $fib[ $i - 1 - $m ] );
		}
	
	$debug and print "@fib";
	
	print $fib[ $n - 1 ];
	}