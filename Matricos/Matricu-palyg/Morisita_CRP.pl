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
my $Horn = 0;

for (@opt){
	/-horn/ and do {
		$Horn = 1;
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

if( @ARGV != 2 ){
	die "\@ARGV != 2; There must be two data files to compare.\n";
	}

#!! for (@ARGV){
	
##	print "<<@ARGV>>\n";
	
	open my $in0, '<', $ARGV[0] or die "$0: [$ARGV[0]] ... : $!\n";
	open my $in1, '<', $ARGV[1] or die "$0: [$ARGV[1]] ... : $!\n";
	my @data;
	push @data, [ map { chomp; [ split /$split/ ] } grep m/./, <$_> ] for $in0, $in1;
	
	for (@data){
	##	print "<@{$_}>\n" for @{ $_ };
		}
	
#	exit;
	
	my @gylis;
	my @dim;
	
	for my $u (0 .. 1){
		( $gylis[$u], $dim[$u] ) = @{ shift @{ $data[$u] } };
	##	print "[( $gylis[$u], $dim[$u] )]\n";
		$gylis[$u] != @{ $data[$u][0] } and 
			die "$0: gylis[$u] ($gylis[$u]) != num of columns. Maybe incorrect split?\n";
	}
	
	if( $dim[0] != $dim[1] ){
		die "Number of dimensions must be equal!\n";
		}
	
	my $dim = $dim[0];
	
	my @dim_gylis = @data;
	for my $u (0 .. 1){
		$debug and print "@{$_}\n" for @{ $dim_gylis[$u] };
	}
	
	my @Xi;
	
	for my $u (0 .. 1){
		for my $i (1 .. $gylis[$u]){
			my $sum;
			for my $j (1 .. $dim){
				$sum += $dim_gylis[$u][ $j-1 ][ $i-1 ];
			#%    print "  $i $j: $sum";
			}
			push @{ $Xi[$u] }, $sum;
		}
	}

	my @lambda_i;
	
	for my $u (0 .. 1){
		for my $i (1 .. $gylis[$u]){
			my $sum;
			for my $j (1 .. $dim){
				$sum += ( $dim_gylis[$u][ $j-1 ][ $i-1 ] * ( $dim_gylis[$u][ $j-1 ][ $i-1 ] - $Horn ) ) /
						( $Xi[$u][ $i-1 ] * ( $Xi[$u][ $i-1 ] - $Horn ) );
			}
		#%	printf "    lambda_i [%d]: %s\n", $i, $sum;
			push @{ $lambda_i[$u] }, $sum;
		}
	}
	#%  print "@lambda_i";

	my @matrix;

	for my $i (1 .. $gylis[0]){
		my @line;
		for my $j (1 .. $gylis[1]){
		    my $sum;
		    for my $r (0 .. $dim - 1){
		        $sum += $data[0][$r][ $i-1 ] * $data[1][$r][ $j-1 ];
		    ##    print "[$i:$data[0][$r][ $i-1 ] * $j:$data[1][$r][ $j-1 ]]\n";
		    }
		    push @line, 2 * $sum / 
		        ( ($lambda_i[0][ $i-1 ] + $lambda_i[1][ $j-1 ]) * $Xi[0][ $i-1 ] * $Xi[1][ $j-1 ] );
		}
		push @matrix, [ @line ];
	}

	print map "$_\n", join "$join", @{$_} for @matrix;

#!! } # end for @ARGV

