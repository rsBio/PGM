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
	/-nosep/ and do {
		$split = '';
	};
	/-d$/ and do {
		$debug = 1;
	};
}

my $target;
my @compact_target;

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; $_ } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	if( not defined $target ){
		$target = join "", @data;
		
		$target and push @compact_target, [ ( substr $target, 0, 1, '' ) => 1 ];
		
		for my $i ( 0 .. -1 + length $target ){
			my $ch = substr $target, $i, 1;
			if( $ch eq $compact_target[ @compact_target - 1 ][ 0 ] ){
				$compact_target[ @compact_target - 1 ][ 1 ] ++;
				}
			else{
				push @compact_target, [ $ch => 1 ];
				}
			}
		
		$debug and print "compact_target: ";
		$debug and print "<@{$_}>, " for @compact_target;
		$debug and print "\n";
		next;
		}
	
	for my $search ( @data ){
		my $len_of_search = length $search;
		
		my @compact_search;
		$search and push @compact_search, [ ( substr $search, 0, 1, '' ) => 1 ];
		
		for my $i ( 0 .. -1 + length $search ){
			my $ch = substr $search, $i, 1;
			if( $ch eq $compact_search[ @compact_search - 1 ][ 0 ] ){
				$compact_search[ @compact_search - 1 ][ 1 ] ++;
				}
			else{
				push @compact_search, [ $ch => 1 ];
				}
			}
		
		$debug and print "compact_search: ";
		$debug and print "[@{$_}], " for @compact_search;
		$debug and print "\n";
		
		my @coords;
		my $pos = 0;
		my $used = 0;
		
		for( my $i = 0; $i < @compact_target - @compact_search + 1; $i ++ ){
			if( $compact_target[ $i ][ 0 ] eq $compact_search[ 0 ][ 0 ] and 
				$compact_target[ $i ][ 1 ] - $used >= $compact_search[ 0 ][ 1 ]
				){
				my $fail = 0;
				for( my $j = $i + 1; $j < $i + @compact_search - 1; $j ++ ){
					$compact_target[ $j ][ 0 ] eq $compact_search[ $j - $i ][ 0 ] and 
					$compact_target[ $j ][ 1 ] == $compact_search[ $j - $i ][ 1 ] or
						++ $fail and last;
					}
				if( not( $compact_target[ $i + @compact_search - 1 ][ 0 ] eq 
						$compact_search[ -1 ][ 0 ] and 
					$compact_target[ $i + @compact_search - 1 ][ 1 ] >= 
						$compact_search[ -1 ][ 1 ]
						)
					){
						$fail = 1;
					}
				if( not $fail ){
					push @coords, join '-', $pos, $pos + $len_of_search - 1;
					$used += $compact_search[ -1 ][ 1 ];
					$i += @compact_search - 2;
					$pos += $len_of_search;
					}
				else{
					$pos += $compact_target[ $i ][ 1 ] - $used;
					$used = 0;
					}
				}
			else{
				$pos += $compact_target[ $i ][ 1 ] - $used;
				$used = 0;
				}
			}
		
		$debug and print "search:[$search]\n";
		print "total: ", ~~ @coords, "\n";
		$debug and print map "$_\n", join " ", @coords;
		}
	
}
