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
my $length = 100;
my $join = " ";
my $uniform = 1;
my $rand = 0;
my $rand_binary = 0;
my $sin = 0;
my $A = 0;
my $B;
my $C;
my $rand_replacements = 0;
my $rand_deletions = 0;

for( @opt ){
	/-dim(\d+)/ and do {
		$dim = $1;
	};
	/-length(\d+)/ and do {
		$length = $1;
	};
	/-uniform/ and do {
		$uniform = 1;
		$rand = 0;
		$rand_binary = 0;
		$sin = 0;
	};
	/-rand$/ and do {
		$uniform = 0;
		$rand = 1;
		$rand_binary = 0;
		$sin = 0;
	};
	/-rand-binary/ and do {
		$uniform = 0;
		$rand = 0;
		$rand_binary = 1;
		$sin = 0;
	};
	/-sin/ and do {
		$uniform = 0;
		$rand = 0;
		$rand_binary = 0;
		$sin = 1;
	};
	/-A(\d+)/ and do {
		$A = $1;
	};
	/-B(\d+)/ and do {
		$B = $1;
	};
	/-C(\d+)/ and do {
		$C = $1;
	};
	/-rand-replacements/ and do {
		$rand_replacements = 1;
	};
	/-rand-deletions/ and do {
		$rand_deletions = 1;
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
	my @arr;
	if( $uniform ){
		@arr = ( $A ) x $length;
		}
	elsif( $rand ){
		@arr = map { rand $A } 1 .. $length;
		}
	elsif( $rand_binary ){
		@arr = map { int 0.5 + rand $A } 1 .. $length;
		}
	elsif( $sin ){
		@arr = map { 1 + sin $_ } map { $_ / 3 } 1 .. $length;
		}
	
	$debug and print "arr:[@arr]\n";
	
	if( $rand_replacements ){ # ..?
		OUTER:
		for my $w ( map { ( $_ ) x 3 } 1 .. $length / 4 ){
			
			for my $rand_replacement ( 1 .. rand( 1 + 1 / $w ** 1 ) ){
				$debug and print $w . "\n";
				
				my $start = int rand( $length - $w - 1 );
				@arr[ $start .. $start + $w - 1 ] = ( 0 ) x $w;
				
				redo OUTER;
				}
			}
		}
	
	if( $rand_deletions ){ # ...
		my $w = @arr / 4;
		@arr = @arr;
		}
	
	print map "$_\n", join ' ', map s/\.\d{5}\K.*//gr, @arr;
	}




