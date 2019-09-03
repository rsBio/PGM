#!/usr/bin/perl

use warnings;
use strict;

{ local $/ ; $_ = <> };

$\ = $/;

my( undef, @strings ) = split /\>/;

my %GC_contents;

for( @strings ){
	my( $id, $nucleotides ) = split ' ', $_, 2;
	$nucleotides =~ s/\s//g;
	
	my $GC_content = 100 * length( $nucleotides =~ y/AT//dr ) / length $nucleotides;
	
	$GC_contents{ $id } = $GC_content;
	}

my $key_max = ( sort { $GC_contents{ $b } <=> $GC_contents{ $a } } keys %GC_contents )[ 0 ];

print for $key_max, $GC_contents{ $key_max };
