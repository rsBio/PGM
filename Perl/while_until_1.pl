#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $i = 0;

print 'while:';

print join '', map "[$_]", 
	do{ while( $i ){ 5 } },
	do{ 6 while $i },
	;

print join '', map "[$_]", 
	do{ while( 0 ){ 7 } },
	do{ while( '' ){ 8 } },
	do{ while( !1 ){ 9 } },
	do{ while( () ){ 10 } },
	;

print join '', map "[$_]", 
	do{ 17 while 0 },
	do{ 18 while '' },
	do{ 19 while !1 },
	do{ 20 while () },
	;

print 'until:';

print join '', map "[$_]",
	'B' . do{ until( 1 ){ 27 } },
	2 + do{ until( !0 ){ 28 } },
	
	'B' . do{ 37 until 1 },
	2 + do{ 38 until 1 },
	
	'B' . do{ 39 until !0 },
	2 + do{ 40 until !0 },
	;