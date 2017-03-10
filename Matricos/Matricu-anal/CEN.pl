#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $split = " ";
my $join = " ";
my $pbm = 0;
my $to_pbm = 0;
my $to_pgm = 0;
my $power = 2;
my $print_RR = 0;
my $print_ratios = 0;

for (@opt){
	/-pbm/ and do {
		$pbm = 1;
	};
	/-power(\d+)/ and do {
		$power = $1;
	};
	/-rr/i and do {
		$print_RR = 1;
	};
	/-ratios/ and do {
		$print_ratios = 1;
	};
	/-topbm/ and do {
		$to_pbm = 1;
	};
	/-topgm/ and do {
		$to_pgm = 1;
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
	/-nosep/ and do {
		$split = '';
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
	/-tonosep/ and do {
		$join = '';
	};
	/-d/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = grep m/./, (defined $in ? <$in> : <STDIN>);
	chomp @data;
	
	my( $rows, $cols );
	if( $pbm ){
		shift @data;
		( $rows, $cols ) = reverse split ' ', shift @data;
	}
	else{
		( $rows, $cols ) = (0 + @data, 0 + split /$split/, $data[0] );
	}

	@data = map { [ split /$split/ ] } @data;
	
	my @CEN;
	my @RR;
	my @ratios;
	
	for my $col ( 0 .. $cols - 1 ){
		
		my $sum = 0;
		my $RR = 0;
		
		for my $row ( 0 .. $rows - 1 ){
			
			next if not $data[ $row ][ $col ];
			$RR ++;
			
			$sum += abs( $row - $col ) ** $power;
			
			}
		
		my $CEN = sprintf "%.4f", $RR > 1 ? $RR / $rows / ( $sum / ( $RR - 1 ) ) ** (1 / $power) : 0;
	#!	my $CEN = sprintf "%.4f", $sum > 0 ? $RR / $sum : 0;
		push @CEN, $CEN;
		push @RR, $RR;
		push @ratios, $RR ? $CEN / $RR : 0;
		}
	
	
	print do { local $" = $join; "@CEN\n" }; 
	if( $print_RR ){
		print do { local $" = $join; "@RR\n" }; 
		}
	if( $print_ratios ){
		print do { local $" = $join; "@ratios\n" }; 
		}
}