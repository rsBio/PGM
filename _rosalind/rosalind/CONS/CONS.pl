#!/usr/bin/perl

use warnings;
use strict;

{ local $/ ; $_ = <> };

$\ = $/;

my( undef, @strings ) = split /\>/;

s/.*\n// for @strings;
s/\s//g for @strings;

my $len = length $strings[ 0 ];

my %h = map { ; $_ => [ ( 0 ) x $len ] } qw( A C G T );

for( @strings ){
	
	/
		.
		(?{ $h{ $& }[ ( pos ) - 1 ] ++ })
		(*F)
		/x;
	}

my $consensus = '';

for my $i ( 0 .. $len - 1 ){
	$consensus .= ( sort { $h{ $b }[ $i ] <=> $h{ $a }[ $i ] } keys %h )[ 0 ];
	}

print $consensus;
print "$_: @{ $h{ $_ } }" for sort keys %h;
