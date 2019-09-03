#!/usr/bin/perl

use warnings;
use strict;

{ local $/ ; $_ = <> };

$\ = $/;

my %h;

/
	.
	(?{ $h{ $& } ++ })
	(*F)
/x;

print join ' ', map $h{ $_ }, qw( A C G T );
