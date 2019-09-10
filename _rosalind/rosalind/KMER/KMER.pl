#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

{ local $/ ; $_ = <> };

s/\>.*\n//;
s/\s//g;

my %h;

/
	(?=(.{4}))
	(?{ $h{ $1 } ++ })
	(*F)
	/x;

$debug and print join ' ', sort keys %h;

my @kmers;

for my $i ( '0000' .. '3333' ){
	next if $i =~ /[4-9]/;
	$i =~ y/0-4/ACGT/;
	push @kmers, $h{ $i } // 0;
	}

print "@kmers";