#!/usr/bin/perl

use strict;
use warnings;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $split = " ";
my $join = ",";

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

	my( $gylis, $dim ) = @{ shift @data };
	$gylis != @{ $data[0] } and 
		die "$0: gylis ($gylis) != num of columns. Maybe incorrect split?\n";
	
	my @dim_gylis = @data;

	$debug and print "@{$_}\n" for @dim_gylis;

	my @Xi;

	for my $i (1 .. $gylis){
		my $sum;
		for my $j (1 .. $dim){
		    $sum += $dim_gylis[ $j-1 ][ $i-1 ];
		#%    print "  $i $j: $sum";
		}
		push @Xi, $sum;
	}

	my @lambda_i;

	for my $i (1 .. $gylis){
		my $sum;
		for my $j (1 .. $dim){
		    $sum += ( $dim_gylis[ $j-1 ][ $i-1 ] ** 2 - $dim_gylis[ $j-1 ][ $i-1 ] ) /
					( $Xi[ $i-1 ]                ** 2 - $Xi[ $i-1 ] );
		}
	#%	printf "    lambda_i [%d]: %s\n", $i, $sum;
		push @lambda_i, $sum;
	}

	#%  print "@lambda_i";

	my @matrix;

	for my $i (1 .. $gylis){
		my @line;
		for my $j (1 .. $gylis){
		    my $sum;
		    for my $r (@dim_gylis){
		        $sum += $r->[ $i-1 ] * $r->[ $j-1 ];
		    }
		    push @line, 2 * $sum / 
		        ( ($lambda_i[ $i-1 ] + $lambda_i[ $j-1 ]) * $Xi[ $i-1 ] * $Xi[ $j-1 ] );
		}
		push @matrix, [ @line ];
	}

	print map "$_\n", join "$join", @{$_} for @matrix;

}

