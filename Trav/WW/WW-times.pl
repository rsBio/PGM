#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $split = "\t";
my $join = "\n";
my $MB = 20;
my $lvlS = 1;
my $lvlF = 100;
my $fives = 0;
my $days = 0;
my $onlydays = 0;

for (@opt){
	/-mb(\d+)/ and do {
		$MB = $1;
	};
	/-lvl(\d+),(\d+)/ and do {
		$lvlS = $1;
		$lvlF = $2;
	};
	/-fives/ and do {
		$fives = 1;
	};
	/-days/ and do {
		$days = 1;
	};
	/-onlydays/ and do {
		$onlydays = 1;
		$days = 1;
	};
	/-tsv/ and do {
		$split = "\t";
	};
	/-csv/ and do {
		$split = ',';
	};
	/-cssv/ and do {
		$split = ', ';
	};
	/-ssv/ and do {
		$split = ' ';
	};
	/-d$/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split /$split/ ] } grep m/./, (defined $in ? <$in> : <STDIN>);
	
	shift @{ $_ } for @data;
	my $col_names = shift @data;
	
	my $sum;
	
	if( defined $lvlS ){
		
		diff( $lvlS, $lvlF );
		
	}
	
	if( $fives ){
		
		for my $i ( 1 .. 20 ){
			diff( $i * 5 - 4, $i * 5 );
			}
	}

		sub diff {
			my( $lvlS, $lvlF ) = @_;
			
			my $sum = 0;
				
			for my $i ( $lvlS - 1 .. $lvlF - 1 ){
				$debug and print " " x 4, $data[ $i ][ $MB - 1 ], "\n";;
				my( $h, $m, $s) = map s/^0//r, split /:/, $data[ $i ][ $MB - 1 ];
				$sum += $h * 3600 + $m * 60 + $s * 1;
			}
			
		##	$debug and print "sum: $sum";
			
			$sum >>= 1; # building 2x speed
			
			my( $h, $m, $s );
			$h = int $sum / 3600;
			$sum %= 3600;
			$m = int $sum / 60;
			$sum %= 60;
			$s = $sum;
			
			if( ! $onlydays ){
				print join ' -', map { sprintf "%3d", $_ } $lvlS, $lvlF;
				print "\t";
				print join ":", map { sprintf "%02d", $_ } $h, $m, $s;
				print "\n";
			}
			
			if( $days ){
				my $days = $h / 24;
				$h %= 24;
				
				print join ' -', map { sprintf "%3d", $_ } $lvlS, $lvlF;
				print "\t";
				print join ":", map { sprintf "%02d", $_ } $days, $h, $m, $s;
				print "\n";
			}
		##	return $h, $m, $s;
		}

}