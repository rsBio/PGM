#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $A = "-+3";
my $B = " -+3";
my $C = "- +3";
my $D = "-+ 3";

print map "[$_]", map $_ + 1,
	$A, $B, $C, $D,
	;