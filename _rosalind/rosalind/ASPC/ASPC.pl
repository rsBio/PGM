#!/usr/bin/perl

use warnings;
use strict;
use bigint;

$\ = $/;

my $debug = 0;

while( <> ){
	$debug and print '-' x 15;
	
	my( $n, $m ) = split;
	
	my @N = reverse 1 .. $n;
	my @K = 1 .. $n;
	
	my $prodN = 1;
	$prodN *= $_ for @N;
	
	my $prodK = 1;
	$prodK *= $_ for @K;
	
	$debug and print "$prodN, $prodK";
	
	my $sum = 0;
	
	for my $i ( 0 .. $n - $m ){
		$sum += $prodN / $prodK;
		$prodN /= pop @N;
		$prodK /= pop @K;
		}
	
	print $sum % 1e6;
	}
