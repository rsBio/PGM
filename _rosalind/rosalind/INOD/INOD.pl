#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

while( <> ){
	chomp;
	
	print $_ - 2;
	}
