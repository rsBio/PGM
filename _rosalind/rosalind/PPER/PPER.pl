#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $MOD = 1e6;

while( <> ){
	my( $n, $k ) = split;
	
	my $prod = $n;
	
	while( -- $k and -- $n ){
		$prod *= $n;
		$prod %= $MOD;
		}
	
	print $prod;
	}
