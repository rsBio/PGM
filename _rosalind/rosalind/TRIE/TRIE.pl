#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

$\ = $/;

my $debug = 0;

my @DNAs = <>;
chomp @DNAs;

my $ref_root = [ 1, {} ];

my $label = 1;

my @ans;

for my $DNA ( @DNAs ){
	my $parent = $ref_root;
	
	while( $DNA =~ /./g ){
		
		if( exists $parent->[ 1 ]{ $& } ){
			;
			}
		else{
			$label ++;
			$parent->[ 1 ]{ $& } = [ $label, {} ];
			push @ans, [ $parent->[ 0 ], $label, $& ];
			}
		
		$parent = $parent->[ 1 ]{ $& };
		}
	
	}

$debug and print "label: [$label]";
$debug and print Dumper( $ref_root );

print "@{ $_ }" for @ans;
