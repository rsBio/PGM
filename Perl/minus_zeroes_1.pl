#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my @numbers = qw(
	0.0
	+0.0
	-0.0
	=
	00.0
	000.0
	001.0
	-00.0
	-000.0
	-001.0
	=
	020.0
	-020.0
	020.00
	020.1
	020.01
	=
	01.0
	010.0
	0100.0
	=
	-1.8.0.00
	1.8.0.00
);

my $i = 0;

for( @numbers ){
	m/=/ and print and next;
	print map { sprintf "%10s", $_ } ++ $i, $_, ( eval $_ );
	}
