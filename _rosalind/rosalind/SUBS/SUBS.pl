#!/usr/bin/perl

use warnings;
use strict;

{ local $/ ; $_ = <> };

$\ = $/;

my $pattern;

( $_, $pattern ) = split;

my @pos;

/
	(?= $pattern )
	(?{ push @pos, 1 + pos })
	(*F)
/x;

print "@pos";
