#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

$\ = $/;

{ local $/ ; $_ = <> };

my( undef, @DNAs ) = split /\>/;

s/.*// for @DNAs;
s/\s//g for @DNAs;

my @substrings;
my %substrings;

$DNAs[ 0 ] =~ /	
	.+
	(?{
		$substrings{ $& } = 1;
		})
	(*F)
	/x;

$debug and print for sort keys %substrings;

my @common;

for my $substring ( keys %substrings ){
	my $is_common = 1;
	for my $DNA ( @DNAs ){
		$is_common &&= $DNA =~ /$substring/ or last;
		}
	
	$is_common and push @common, $substring;
	}

$debug and print '-' x 15;

$debug and print for @common;

print +( sort { ( length $b ) <=> ( length $a ) } @common )[ 0 ];
