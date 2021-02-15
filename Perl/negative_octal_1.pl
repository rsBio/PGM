#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $A = -010;
my $B = "-010";
my $C = "- 010";

print map "[$_]", 
	$A, $B, $C,
	;

print map "[$_]", map $_ + 1,
	$A, $B, $C,
	;

print map "[$_]", map ++ $_,
	$A, $B, $C,
	;

# https://perldoc.perl.org/perlnumber#SYNOPSIS
