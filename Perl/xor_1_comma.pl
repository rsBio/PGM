#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $count;

while( <DATA> ){
	chomp;
	
	m/^$/ and do { print 'empty line'; next };
	
	m/[a]/ or ( print 'has "a"' ), $count ++;
	
	( print join '+', reverse split m// ), next if 5 > length;
	
	( print "Found $&" ), last if m/something/;
	}

print $count;

__DATA__
asd

something