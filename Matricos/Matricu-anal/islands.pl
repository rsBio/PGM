#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @FILES;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @FILES, $_);
}

my $split = " ";
my $join = " ";
my $pbm = 1;
my $pgm = 0;  # not implemented
my $to_pgm = 1;
my $to_matrix = 0;

for (@opt){
	/-pbm/ and do {
		$pbm = 1;
	};
	/-tomatrix/ and do {
		$to_matrix = 1;
		$to_pgm = 0;
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
	/-d$/ and $debug = 1;
}

for (@FILES){
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
		( $rows, $cols ) = ( 0 + @data, 0 + split /$split/, $data[0] );
	}

	@data = map { [ split /$split/ ] } @data;
	
	$debug and print "\@data:\n";
	$debug and print "@{$_}\n" for @data;
	$debug and print "-----\n";
	
	( unshift @{ $_ }, 0 ), ( push @{ $_ }, 0 ) for @data;
	unshift @data, [ ( 0 ) x ( $cols + 2 ) ];
	push @data, [ ( 0 ) x ( $cols + 2 ) ];
	
	$debug and print "\@data:\n";
	$debug and print "@{$_}\n" for @data;
	$debug and print "-----\n";
		
	my $island_count = 0;
	my @islands;
	
	for my $i ( 1 .. $rows ){
		for my $j ( 1 .. $cols ){
			next if $data[ $i ][ $j ] == 0;
			
			@{ $islands[ 0 ] } = ();
			$island_count ++;
			
			$debug and print "island nr.: $island_count\n";
			
			my @try = [ $i, $j ];
			
			while( @try ){
				my( $ii, $jj ) = @{ shift @try };
				$debug and print "    [ $ii, $jj ]\n";
				push @{ $islands[ $island_count - 1 ] }, [ $ii, $jj ];
				$data[ $ii ][ $jj ] = 0;
				$data[ $ii + 1 ][ $jj ] =~ s/^1$/0/ and push @try, [ $ii + 1, $jj ];
				$data[ $ii + 1 ][ $jj + 1 ] =~ s/^1$/0/ and push @try, [ $ii + 1, $jj + 1 ];
				$data[ $ii + 1 ][ $jj - 1 ] =~ s/^1$/0/ and push @try, [ $ii + 1, $jj - 1 ];   
				$data[ $ii - 1 ][ $jj ] =~ s/^1$/0/ and push @try, [ $ii - 1, $jj ];  
				$data[ $ii - 1 ][ $jj + 1 ] =~ s/^1$/0/ and push @try, [ $ii - 1, $jj + 1 ];   
				$data[ $ii - 1 ][ $jj - 1 ] =~ s/^1$/0/ and push @try, [ $ii - 1, $jj - 1 ]; 
				$data[ $ii ][ $jj + 1 ] =~ s/^1$/0/ and push @try, [ $ii, $jj + 1 ];
				$data[ $ii ][ $jj - 1 ] =~ s/^1$/0/ and push @try, [ $ii, $jj - 1 ];
				}
			
			$debug and print map "$_\n", join ',', 
				map "[@{ $_ }]", @{ $islands[ $island_count - 1 ] };
			}
		}
	
	my $max_size = 0;
	
	for my $island ( @islands ){
		my $size = @{ $island };
		$size > $max_size and $max_size = $size;
		}
	
	my $darker = int $max_size * 0.25;
	
	my @new;
	push @new, [ ( $max_size + $darker ) x $cols ] for 1 .. $rows;
	$debug and print "@{$_}\n" for @new;
	
	for my $island ( @islands ){
		my $size = @{ $island };
		for my $cell ( @{ $island } ){
			my( $i, $j ) = @{ $cell };
			$new[ $i - 1 ][ $j - 1 ] = $max_size - $size;
			}
		}
	
	if( $to_pgm ){
		print "P2\n";
		print $cols, ' ', $rows, "\n";
		print $max_size + $darker, "\n";
		print "@{$_}\n" for @new;
	}
	
	if( $to_matrix ){
		print "@{$_}\n" for @new;
	}
}
