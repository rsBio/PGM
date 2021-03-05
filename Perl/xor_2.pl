#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

while( <DATA> ){
	chomp;
	
	print 1 or print 2 xor print 3 or print 4 xor print 5 or print 6;
	print 11 or print 12 or print 13 xor print 14;
	print 21 xor print 22 xor print 23 xor print 24;
	print 31 or print 32 || print 33 xor print 34;
	print 41 || print 42 or print 43 xor print 44;
	0*print 1 or 0*print 2 xor 0*print 3 or 0*print 4 xor 0*print 5 or 0*print 6;
	}

__DATA__
asd