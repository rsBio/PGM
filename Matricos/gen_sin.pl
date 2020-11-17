#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

srand;

my $dim = 1;
my $rand = 0;
my $wide = 100;
my $join = " ";
my $deletions = 0;

for (@opt){
	/-dim(\d+)/ and do {
		$dim = $1;
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
	/-d\b/ and $debug = 1;
}

@ARGV = @ARGV_2;

@ARGV and die "$0: Should not contain args.\n";

for my $dim (1 .. $dim){
	my @arr = map { 1 + sin $_ } map { $_ / 3 } 1 .. $wide;
	$debug and print "arr(sin):@arr\n";
#	map { $_ = rand(2) } @arr[ 10 + rand($rand) - $rand / 2 .. 20 + rand($rand) - $rand / 2];
#	$debug and print "arr(rand):@arr\n";
	
	print "@arr\n";
	
	OUTER:
	for my $w ( map { ( $_ ) x 3 } 1 .. $wide / 4 ){
		
		for my $deletion ( 1 .. rand( 1 + 1 / $w ** 1 ) ){
			$debug and print $w . "\n";
			
			my $start = int rand( $wide - $w - 1 );
			@arr[ $start .. $start + $w - 1 ] = ( 0 ) x $w;
			
			redo OUTER;
			}
		}
		
#	print "@arr\n";
	print map "$_\n", join ' ', grep $_, @arr;
}




