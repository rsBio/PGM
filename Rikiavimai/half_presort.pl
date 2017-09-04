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

sub half_presort {
	my @A = @_;
	return @A if @A < 2;
	
	for my $i ( 0 .. ( @A / 2 ) - 1 ){
		$A[ $i ] > $A[ -1 - $i ] and do {
			( $A[ $i ], $A[ -1 - $i ] ) = ( $A[ -1 - $i ], $A[ $i ] );
			};
		}
	
	my @arr;
	push @arr, half_presort( @A[ 0 .. ( @A / 2 ) - 1 ] );
	push @arr, half_presort( @A[ @A / 2 .. @A - 1 ] );
	
	return @arr;
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", join ' ', half_presort( @{$_} ) for @data;
}
