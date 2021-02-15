#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my @i = ( 0, '', !1, undef );

for my $i ( @i ){
	print "i:[$i]";
	print join '', map "[$_]", 
		( $i and 5 ), 
		'a' . ( $i and 5 ), 
		0 + ( $i and 5 ),
		;
	}