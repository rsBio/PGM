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

sub bubble_sort {
	my @A = @_;
	for my $i ( reverse 1 .. @A - 1 ){
		for my $j ( 0 .. $i - 1 ){
			$A[ $j ] > $A[ $j + 1 ] and do {
				@A[ $j, $j + 1 ] = @A[ $j + 1, $j ];
				}
			}
		}
	
	return @A;
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", join ' ', bubble_sort( @{$_} ) for @data;
}
