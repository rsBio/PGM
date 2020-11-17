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

sub binary_tree {
	my @A = @_;
	my %tree;
	my $min = 0;
	my @refs;
	
	for my $number ( @A ){
		my $ref = \%tree;
		my $depth = 0;
		push @refs, $ref;
		
		while( exists $ref->{ 'value' } ){
			$ref = $number < $ref->{ 'value' } ?
					\%{ $ref->{ 'left' } }
				:
					\%{ $ref->{ 'right' } }
				;
			push @ref, $ref;
			$depth ++;
			if( $depth > $min + 1 ){
				# TO BALANCE
				my $tmp_ref = $refs[ -4 ];
				# ?????????
				# ????????
				}
			}
		
		$ref->{ 'value' } = $number;
		}
	
	$debug and print "=" x 20, $/;
	$debug and print "@A\n";
	$debug and print Dumper( \%tree );
	$debug and print "$_ ==> $tree{ $_ }\n" for keys %tree;
	return %tree;
	}

sub binary_tree_sort {
	my %tree = binary_tree( @_ );
	my @A;
	
	my @refs;
	push @refs, \%tree;
	
	while( @refs ){
		my $ref = pop @refs;
		
		while( exists $ref->{ 'left' } ){
			push @refs, $ref;
			$ref = \%{ $ref->{ 'left' } };
			}
		
		push @A, $ref->{ 'value' };
		@refs and delete $refs[ -1 ]->{ 'left' };
		
		if( exists $ref->{ 'right' } ){
			$ref = \%{ $ref->{ 'right' } };
			push @refs, $ref;
			}
		}
	
	return @A;
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", join ' ', binary_tree_sort( @{$_} ) for @data;
}
