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
}

sub selection_1_sort {
	my @A = @_;
	for my $i ( reverse 1 .. @A - 1 ){
		my $max = $A[ $i ];
		my $max_j = $i;
		for my $j ( 0 .. $i - 1 ){
			$A[ $j ] > $max and do {
				$max = $A[ $j ];
				$max_j = $j;
				}
			}
		( @A[ $max_j, $i ] ) = ( @A[ $i, $max_j ] );
		}
	
	return @A;
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", join ' ', selection_1_sort( @{$_} ) for @data;
}
