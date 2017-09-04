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

sub merge_sorted_lists_1 {
	my @refs = @_;
	my @A;
	
	while( @refs = grep { @{ $_ } } @refs ){
		
		my $min = $refs[ 0 ]->[ 0 ];
		my $ref_min = $refs[ 0 ];
		
		for my $ref ( @refs ){
			$min > $ref->[ 0 ] and do {
				$min = $ref->[ 0 ];
				$ref_min = $ref;
				};
			}
		
		push @A, shift @{ $ref_min };
		
		}
	
	return @A;
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", join ' ', merge_sorted_lists_1( @data );
}
