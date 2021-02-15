#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $i = 0;

print 5 . do{ if( "" ){ "A" } elsif( $i ){ "B" } } . "a";

print 6 . do{ if( $i ){ "A" } elsif( 0 ){ "B" } } . "b";

print 8 . do{ if( $i ){ "A" } elsif( 0 ){ "B" } elsif( !1 ){ "C" } } . "c";

print 11 . do{ if( "" ){ "A" } elsif( 0 ){ "B" } elsif( $i ){ "C" } } . "d";

print 15 . do{ if( "" ){ "A" } elsif( $i ){ "B" } elsif( 0 ){ "C" } } . "e";

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