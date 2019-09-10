#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;
my $debug_2 = 0;

$\ = $/;

while( <> ){
	chomp;
	my $n = $_;
	
	@_ = split ' ', <>;
	
	my @up = longest_increasing_subsequence( @_ );
	
	$debug and print "up: [@up]";
	print "@up";
	
	@_ = map { @_ - $_ + 1 } @_;
	
	my @down = longest_increasing_subsequence( @_ );
	
	@down = map { @_ - $_ + 1 } @down;
	
	$debug and print "down: [@down]";
	print "@down";
	}
	
sub longest_increasing_subsequence{	
	my @numbers = @_;
	
	my @A;
	
	for my $i ( @numbers ){
		
		my $max_len = 0;
		
		my @candidates;
		
		for my $ref_j ( @A ){
			if( ${ $ref_j }[ @{ $ref_j } - 1 ] < $i ){
				push @candidates, $ref_j;
				@{ $ref_j } > $max_len and $max_len = @{ $ref_j };
				}
			}
		
		my $found = 0;
		
		for my $ref_candidates ( @candidates ){
			if( @{ $ref_candidates } == $max_len and $found == 0 ){
				push @A, [ @{ $ref_candidates }, $i ];
				$found = 1;
				last;
				}
			}
		
		$found or push @A, [ $i ];
		
		$debug and print '-' x 5;
		$debug and print " @{ $_ }" for @A;
		
		$debug_2 and print ~~ @A, " ", 0 + eval join '+', map { ~~ @{ $_ } } @A;
		}
	
	my( $max_len_ref ) = 
		map { $_->[ 0 ] }
		sort { $b->[ 1 ] <=> $a->[ 1 ] }
		map { [ $_, scalar @{ $_ } ] } @A;
		
	return @{ $max_len_ref };
	}