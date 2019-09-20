#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

while( my $n = <> ){
	chomp $n;
	
	my %A = map { $_ => 1 } <> =~ /\d+/g;
	my %B = map { $_ => 1 } <> =~ /\d+/g;
	
	$debug and print join ', ', sort { $a <=> $b } keys %A;
	$debug and print join ', ', sort { $a <=> $b } keys %B;
	
	my %union;
	map $union{ $_ } = 1, keys %A, keys %B;
	
	my %intersection;
	map $intersection{ $_ } ++, keys %A, keys %B;
	
	%intersection = map { $_ => 1 } grep { $intersection{ $_ } == 2 } keys %intersection;
	
	my %A_minus_B;
	%A_minus_B = map { $_ => 1 } grep { not exists $B{ $_ } } keys %A;
	
	my %B_minus_A;
	%B_minus_A = map { $_ => 1 } grep { not exists $A{ $_ } } keys %B;
	
	my %Ac;
	%Ac = map { $_ => 1 } grep { not exists $A{ $_ } } 1 .. $n;
	
	my %Bc;
	%Bc = map { $_ => 1 } grep { not exists $B{ $_ } } 1 .. $n;
	
	print for map {
		map "{$_}", join ', ', sort { $a <=> $b } keys %{ $_ };
		} \%union, \%intersection, \%A_minus_B, \%B_minus_A, \%Ac, \%Bc;
	}
