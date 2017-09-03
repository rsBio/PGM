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

sub heap {
	my @A = @_;
	my %heap;
	
	@A and $heap{ 'value' } = shift @A;
	my @ways = map { -$_ } 1 .. 20;
	
	for my $number ( @A ){
		my $ref = \%heap;
		
		$ways[ 0 ] < 0 and do {
			my $way_gen = abs shift @ways;
			
			unshift @ways, map {
				sprintf "%0${way_gen}b", $_
				} 0 .. 2 ** $way_gen - 1;
			};
		
		my @way = split //, shift @ways;
		$debug and print "\@way:[@way]\n";
		
		for my $i ( @way ){
			my $direction = $i == 0 ? 'left' : 'right';
			
			$ref->{ 'value' } > $number and do {
				( $ref->{ 'value' }, $number ) = ( $number, $ref->{ 'value' } );
				};
			
			if( exists $ref->{ $direction } ){
				$ref = \%{ $ref->{ $direction } };
				}
			else{
				$ref->{ $direction }->{ 'value' } = $number;
				last;
				}			
			}
		}
	
	$debug and print "=" x 20, $/;
	$debug and print "\@A:@A\n";
	$debug and print Dumper( \%heap );
	$debug and print "$_ ==> $heap{ $_ }\n" for keys %heap;
	return %heap;
	}

sub heap_sort {
	my %heap = heap( @_ );
	my @A;
	
	my @refs;
	push @refs, \%heap;
	
	while( @refs ){
		my $min_ref = shift @refs;
		push @A, $min_ref->{ 'value' };
		
		exists $min_ref->{ 'left' } and do {
			my $value = $min_ref->{ 'left' }->{ 'value' };
			
			my $cnt = 0;
			for my $ref ( @refs ){ 
				last if $value <= $ref->{ 'value' };
				$cnt ++;
				}
			
			splice @refs, $cnt, 0, \%{ $min_ref->{ 'left' } };
			};
		
		exists $min_ref->{ 'right' } and do {
			my $value = $min_ref->{ 'right' }->{ 'value' };
			
			my $cnt = 0;
			for my $ref ( @refs ){ 
				last if $value <= $ref->{ 'value' };
				$cnt ++;
				}
			
			splice @refs, $cnt, 0, \%{ $min_ref->{ 'right' } };
			};
		
		}
	
	return @A;
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", join ' ', heap_sort( @{$_} ) for @data;
}
