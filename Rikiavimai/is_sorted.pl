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

sub is_sorted {
	my @A = @_;
	my $false = 0;
	
	for my $i ( 0 .. @A - 2 ){
		last if $false += $A[ $i ] > $A[ $i + 1 ];
		}
	
	return $false ? "FALSE" : "TRUE";
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", is_sorted( @{$_} ) for @data;
}
