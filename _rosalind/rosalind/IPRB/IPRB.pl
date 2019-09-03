#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

while( <> ){
	my( $k, $m, $n ) = split;
	
	my $prob = 0;
	
	$prob += $k / ( $k + $m + $n ) * ( ( $k - 1 ) / ( $k + $m + $n - 1 ) ) * 1/1;
	$prob += $k / ( $k + $m + $n ) * ( ( $m - 0 ) / ( $k + $m + $n - 1 ) ) * 1/1;
	$prob += $k / ( $k + $m + $n ) * ( ( $n - 0 ) / ( $k + $m + $n - 1 ) ) * 1/1;
	
	$prob += $m / ( $k + $m + $n ) * ( ( $k - 0 ) / ( $k + $m + $n - 1 ) ) * 1/1;
	$prob += $m / ( $k + $m + $n ) * ( ( $m - 1 ) / ( $k + $m + $n - 1 ) ) * 3/4;
	$prob += $m / ( $k + $m + $n ) * ( ( $n - 0 ) / ( $k + $m + $n - 1 ) ) * 1/2;
	
	$prob += $n / ( $k + $m + $n ) * ( ( $k - 0 ) / ( $k + $m + $n - 1 ) ) * 1/1;
	$prob += $n / ( $k + $m + $n ) * ( ( $m - 0 ) / ( $k + $m + $n - 1 ) ) * 1/2;
	$prob += $n / ( $k + $m + $n ) * ( ( $n - 1 ) / ( $k + $m + $n - 1 ) ) * 0/1;
	
	print $prob;
	}
