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

$DNAs[ 0 ] =~ /	
	.+
	(?{
		push @substrings, $&;
		})
	(*F)
	/x;

$debug and print for @substrings;

my @common;

for my $substring ( @substrings ){
	my $is_common = 1;
	for my $DNA ( @DNAs ){
		$is_common &&= $DNA =~ /$substring/ or last;
		}
	
	$is_common and push @common, $substring;
	}

$debug and print '-' x 15;

$debug and print for @common;

print +( sort { ( length $b ) <=> ( length $a ) } @common )[ 0 ];
