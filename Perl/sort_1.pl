#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my @data = <DATA>;
chomp @data;

for my $data ( @data ){
	print '-' x 15;
	print "[ $data ]";
	
	my $i = 0;

	my @i = map { [ $_, ++ $i ] } split ' ', $data;
	
	my $string_A = '';
	my $string_B = '';
	
	my $cnt = 0;
	
	@i = sort {
		$cnt ++;
	#	print " " . '-' x 5;
	#	print " [ $a->[ 1 ] <=> $b->[ 1 ] ]";
	#	print " [ $a->[ 0 ] <=> $b->[ 0 ] ]";
	#	print " [ " . ( join ' ', map $_->[ 0 ], @i ) . " ]";
		$string_A .= ' ' . $a->[ 0 ];
		$string_B .= ' ' . $b->[ 0 ];
		$a->[ 0 ] <=> $b->[ 0 ];
		} @i;
	
	print $string_A;
	print $string_B;
	print "length:", 0 + @i, ", cnt:$cnt";
	print "sorted:[ " . ( join ' ', map $_->[ 0 ], @i ) . " ]";
	}

__DATA__
5 4 1 3 2 7 6
9 8 7 6 5 4 3 2 1
1 2 3 4 5 6 7 8 9
1 1 1 1 1 1 1 1 1
1 1 1 1 2 2 2 2
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15