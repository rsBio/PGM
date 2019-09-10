#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

{ local $/ ; $_ = <> };

( undef, @_ ) = split /\>/;

s/.*\n// for @_;
s/\s//g for @_;

for my $i ( @_ ){
	my @row;
	
	for my $j ( @_ ){
		my $distance = Hamm( $i, $j );
		push @row, $distance / length $_[ 0 ];
		}
	
	print "@row";
	}


sub Hamm{
	my( $A, $B ) = @_;
	
	my $Hamm = 0;
	
	for my $i ( 0 .. -1 + length $A ){
		$Hamm += 
			( substr $A, $i, 1 ) ne
			( substr $B, $i, 1 )
			;
		}
	
	return $Hamm;
	}