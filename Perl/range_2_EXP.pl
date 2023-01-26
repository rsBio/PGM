#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $c = " ";

print map "[$_]", 
	" " .. 3,
	" " .. "4",
	++ $c
	;

print map "[$_]", 
	"-010" .. "4",
	;

print map "[$_]", 
	"01" .. "4",
	;

print map "[$_]", 
	"01" .. "13",
	;