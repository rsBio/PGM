#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

print 5 . do{ if( "" ){ 5 } elsif( 0 ){ 6 } } . "a"; 
print 5 + scalar do{ if( "" ){ 5 } elsif( 0 ){ 6 } } . "a"; 

my $i = 0;

print 5 . do{ if( "" ){ "A" } elsif( $i ){ "B" } } . "a"; 

exit;

my @i = ( 0, '', !1, undef );

for my $i ( @i ){
	print "i:[$i]";
	print join '', map "[$_]", 
		do{ if( 0 ){ 5 } elsif( "" ){ 6 } }, 
		'a' . do{ if( 0 ){ 5 } elsif( "" ){ 6 } }, 
		0 + do{ if( 0 ){ 5 } elsif( "" ){ 6 } },
		;
	}