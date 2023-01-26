#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;


my $something = q(
	-asd
	- asd
	+asd
	+ asd
	- -asd
	=
	-_
	- _
	-  _
	-  ____
	-  ____0
	-  ____0.4
	=
	0.0.0.0
	1.0.0.0
	74.117.115.116
	=
	-0060
	-00_60
	-0_0_60
	-00_0_60
);

my @something = split "\n", $something;

s/^\s+//, s/\s+$// for @something;

@something = grep length, @something;

my $i = 0;

for( @something ){
	m/=/ and print and next;
	print map { sprintf "%10s", $_ } ++ $i, $_, ( eval $_ ), "", $@;
	}

