#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;
    
my $debug = 0;

my @FILES;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @FILES, $_);
}

my $split = " ";
my $find;
my $last = 0;

for (@opt){
	/-find(\d+)/ and do {
		$find = $1;
	};
	/-last/ and do {
		$last = 1;
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
	/-d$/ and do {
		$debug = 1;
	};
}

sub binary_tree {
	my @A = @_;
	my %tree;
	
	for my $number ( @A ){
		my $ref = \%tree;
		
		while( exists $ref->{ 'value' } ){
			$ref = $number < $ref->{ 'value' } ?
					\%{ $ref->{ 'left' } }
				:
					\%{ $ref->{ 'right' } }
			}
		
		$ref->{ 'value' } = $number;
		}
	
	$debug and print "=" x 20, $/;
	$debug and print "@A\n";
	$debug and print Dumper( \%tree );
	$debug and print "$_ ==> $tree{ $_ }\n" for keys %tree;
	return %tree;
	}

sub is_in_array__binary_tree {
	$find //= shift;
	my %tree = binary_tree( @_ );
	my $found = 0;
	my $ref = \%tree;
	
	while( my $cmp = $find <=> $ref->{ 'value' } || $found ++ ){
		last if $last and $found;
		
		my $direction = $cmp == -1 ? "left" : "right";
		
		if( exists $ref->{ $direction } ){
			$ref = \%{ $ref->{ $direction } };
			}
		else{
			last;
			}
		}
	
	return $found ? "TRUE" : "FALSE";
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", join ' ', is_in_array__binary_tree( @{$_} ) for @data;
}
