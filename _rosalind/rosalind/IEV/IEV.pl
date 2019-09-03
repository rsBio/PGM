#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

my @prob = qw( 2 2 2 1.5 1 0 );

while( <> ){
	@_ = split;
	
	my $prob = 0;
	
	for my $i ( 0 .. @_ - 1 ){
		$prob += $_[ $i ] * $prob[ $i ];
		}
	
	print $prob;
	}
