#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

{ local $/ ; $_ = <> };

( undef, @_ ) = split /\>/;

my %h;

for( @_ ){
	chomp;
	my( $id, $nucleotides ) = split ' ', $_, 2;
	
	$nucleotides =~ s/\s//g;
	
	$h{ $id }{ 'nucleotides' } = $nucleotides;
	$h{ $id }{ 'last_3' } = substr $nucleotides, -3;
	$h{ $id }{ 'first_3' } = substr $nucleotides, 0, 3;
	}

$debug and print "$_ --> ", join " ", $h{ $_ }{ 'first_3' }, $h{ $_ }{ 'nucleotides' }, $h{ $_ }{ 'last_3' } for sort keys %h;

my @O3;

for my $id_i ( sort keys %h ){
	for my $id_j ( sort keys %h ){
		next if $id_i eq $id_j;
		if( $h{ $id_i }{ 'last_3' } eq $h{ $id_j }{ 'first_3' } ){
			push @O3, join ' ', $id_i, $id_j;
			}
		}
	}

print for @O3;