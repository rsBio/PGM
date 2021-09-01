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
my $start = 0;
my $A = 1;
my $B = 1;
my $length = 100;
my $join = " ";
my $deletions = 0;

for( @opt ){
	/-dim(\d+)/ and do {
		$dim = $1;
	};
	/-start(\S+)/ and do {
		$start = $1;
	};
	/-A(\S+)/ and do {
		$A = $1;
	};
	/-B(\S+)/ and do {
		$B = $1;
	};
	/-length(\d+)/ and do {
		$length = $1;
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
	
	my $prev = $start;
	my @array = ( $prev );
	
	for my $i ( 1 .. $length ){
		my $new = $A * $prev * ( 1 - $B * $prev );
		push @array, $new;
		$prev = $new;
		}
	
	print map "$_\n", join ' ', @array;
}




