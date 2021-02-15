#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

print  5 + do{ if( "" ){ "A" } elsif( 0  ){ "B" } } . "a"; 

print  6 + do{ if( "" ){ "A" } elsif( 0  ){ "B" } } . "b"; 

print  8 + do{ if( "" ){ "A" } elsif( "" ){ "B" } } . "c"; 

print 11 + do{ if( "" ){ "A" } elsif( "" ){ "B" } } . "d";

print 15 + do{ if( "" ){ "A" } elsif( !1 ){ "B" } } . "e";

print 20 + do{ if( "" ){ "A" } elsif( !1 ){ "B" } } . "f";

print 26 + do{ if( "" ){ "A" } elsif( undef ){ "B" } } . "g";

print 33 . do{ if( "" ){ "A" } elsif( () ){ "B" } } . "h";

print 41 + do{ if( "" ){ "A" } elsif( 0  ){ "B" } elsif( 0  ){ "C" } } . "i";

print 50 + do{ if( "" ){ "A" } elsif( 0  ){ "B" } elsif( "" ){ "C" } } . "j";

print 60 . do{ if( "" ){ "A" } elsif( "" ){ "B" } elsif( 0  ){ "C" } } . "k";

print 71 + do{ if( "" ){ "A" } elsif( 0  ){ "B" } elsif( !1 ){ "C" } } . "l";

print 83 + do{ if( "" ){ "A" } elsif( () ){ "B" } elsif( !1 ){ "C" } } . "m";

print 96 + do{ if( "" ){ "A" } elsif( ""  ){ "B" } elsif( 0 ){ "C" } } . "n";

print 110 + do{ if( "" ){ "A" } elsif( ""  ){ "B" } elsif( () ){ "C" } } . "n";

print 1000 + do{ if( "" ){ "A" } elsif( 0  ){ "B" } elsif( !1 ){ "C" } } . "o";

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