#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my @i = ( 0, '', !1, undef );

for my $i ( @i ){
	print "i:[$i]";
	print join '', map "[$_]", 
		do{ 5 if $i }, 
		'a' . do{ 5 if $i }, 
		0 + do{ 5 if $i },
		;
	}