#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @FILES;
my @opt;

for( @ARGV ){
	/^-\S/ ? ( push @opt, $_ ) : ( push @FILES, $_ );
}

srand;

my $dim = 1;
my $rand = 0;
my $length = 100;
my $join = " ";
my $deletions = 0;

for( @opt ){
	/-dim(\d+)/ and do {
		$dim = $1;
	};
	/-length(\d+)/ and do {
		$length = $1;
	};
	/-rand(\d+)/ and do {
		$rand = $1;
	};
	/-deletions/ and do {
		$deletions = 1;
	};
	/-totsv/ and do {
		$join = "\t";
	};
	/-tocsv/ and do {
		$join = ',';
	};
	/-tocssv/ and do {
		$join = ', ';
	};
	/-tossv/ and do {
		$join = ' ';
	};
	/-d$/ and $debug = 1;
}

@FILES and die "$0: Should not contain files.\n";

for my $dim ( 1 .. $dim ){
	my @arr = map { 1 + sin $_ } map { $_ / 3 } 1 .. $length;
	$debug and print "arr(sin):@arr\n";
	
	if( $deletions ){
		OUTER:
		for my $w ( map { ( $_ ) x 3 } 1 .. $length / 4 ){
			
			for my $deletion ( 1 .. rand( 1 + 1 / $w ** 1 ) ){
				$debug and print $w . "\n";
				
				my $start = int rand( $length - $w - 1 );
				@arr[ $start .. $start + $w - 1 ] = ( 0 ) x $w;
				
				redo OUTER;
				}
			}
		}
	
	print map "$_\n", join ' ', grep $_, @arr;
}




