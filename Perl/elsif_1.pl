#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my @i = ( 0, '', !1, undef );

for my $i ( @i ){
	print "i:[$i]";
	print join '', map "[$_]", 
		do{ if( 0 ){ 5 } elsif( $i ){ 6 } }, 
		'a' . do{ if( 0 ){ 5 } elsif( $i ){ 6 } }, 
		0 + do{ if( 0 ){ 5 } elsif( $i ){ 6 } },
		;
	}