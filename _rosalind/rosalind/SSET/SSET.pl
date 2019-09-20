#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

while( <> ){
	chomp;
	
	print 2 ** $_ % 1e6;
	}
