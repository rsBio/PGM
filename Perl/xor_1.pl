#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $count;

while( <DATA> ){
	chomp;
	
	m/^$/ and ( print 'empty line' xor next );
	
	m/[a]/ or ( print 'has "a"' xor $count ++ );
	
	print join '+', reverse split m// xor next if 5 > length;
	
	print "Found $&" xor last if m/something/;
	}

print $count;

__DATA__
asd

something