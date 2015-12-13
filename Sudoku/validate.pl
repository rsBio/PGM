#!/usr/bin/perl -0777

use warnings;
use strict;
no warnings 'experimental::smartmatch';

while(<>){
	my ($first_line, @lines) = split /\n/;
	my ($len, $n, $m) = split ' ', $first_line;
	
    print "len != n * m !!!\n" if $len != $n * $m;
    
	my @matrix = map { [split] } @lines;
	my @sequence = (1 .. $len);
	my @nums;
	
	for my $i (@sequence){
		@nums = sort {$a <=> $b} @{ $matrix[ $i-1 ] };
		printf "Row $i: %s\n", @sequence ~~ @nums ? 'OK' : 'DIFFER';
	}

	for my $i (@sequence){
		@nums = sort {$a <=> $b} map { $matrix[$_-1][$i-1] } @sequence;
		printf "Column $i: %s\n", @sequence ~~ @nums ? 'OK' : 'DIFFER';
	}

	for (my $i = 1; $i <= @sequence; $i += $n){
		for (my $j = 1; $j <= @sequence; $j += $m){
#%			print "\n";
			@nums = ();
			for my $ii ($i .. $i + $n - 1){
				for my $jj ($j .. $j + $m - 1){
					push @nums, $matrix[$ii-1][$jj-1];
				}
			}
#%			print "@nums\n";
			@nums = sort {$a <=> $b} @nums;
			printf "Block [(%d,%d):(%d,%d)]: %s\n",
				$i, $j, $i + $n - 1, $j + $m - 1,
				@sequence ~~ @nums ? 'OK' : 'DIFFER';
		}
	}

}
