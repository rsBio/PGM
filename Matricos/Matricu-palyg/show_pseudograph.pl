#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $height = 50;

my $split = " ";
my $join = " ";

for (@opt){
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
	/-d/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split /$split/ ] } grep m/./, (defined $in ? <$in> : <STDIN>);

	my( $Mmin, $Mmax ) = (~0, -~0);
	
	for my $graph (@data){
		my( $min, $max ) = (~0, -~0);
		for my $value (@{$graph}){
			$value > $max and $max = $value;
			$value < $min and $min = $value;
		}
		my $wide = $max - $min;
		$min < $Mmin and $Mmin = $min;
		$max > $Mmax and $Mmax = $max;
		$debug and print "min,max,wide:$min|$max|$wide\n";
		
		my @matrix;
		push @matrix, [ (255) x @{$graph} ] for 1 .. $height;
		
		for my $i (1 .. @{$graph}){
			my $ind = $height - ($graph->[$i-1] - $min) * $height / $wide;
			$ind > $height and die "ind($ind) > height($height)\n";
			$ind == $height and $ind --;
			$matrix[ $ind ][$i-1] = 0 
		}
		
	#	print "P2\n";
	#	print @{$graph} . " " . $height . "\n";
	#	print "255\n";
	#	print do { local $" = $join; "@{$_}\n" } for @matrix;
	}
	
	my $Wwide = $Mmax - $Mmin;
	
	my @matrix;
	push @matrix, [ (0) x @{$data[0]} ] for 1 .. $height;
	my $occ_max = 0;
	
	for my $graph (@data){
		for my $i (1 .. @{$graph}){
			my $ind = $height - ($graph->[$i-1] - $Mmin) * $height / $Wwide;
			$ind > $height and die "ind($ind) > height($height)\n";
			$ind == $height and $ind --;
			$matrix[ $ind ][$i-1] ++;
			$matrix[ $ind ][$i-1] > $occ_max and $occ_max = $matrix[ $ind ][$i-1];
		}
	}
	$debug and print "$occ_max\n";
	
	for my $row (@matrix){
		for my $i (1 .. @{$row}){
			$row->[$i-1] or do { $row->[$i-1] = 255; next };
			$row->[$i-1] = int 255 - 255 / $occ_max * $row->[$i-1];
		}
	}
	
	print "P2\n";
	print @{$data[0]} . " " . $height . "\n";
	print "255\n";
	print do { local $" = $join; "@{$_}\n" } for @matrix;
}
