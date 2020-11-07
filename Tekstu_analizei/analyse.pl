#!/usr/bin/perl

use strict;
use warnings;

$_ = do { local $/; <> };

@_ = split;
my %w;
map { $w{$_} ++ } @_;

my @uniq = keys %w;
#	print "$_\n" for @uniq;

	my @p;
	push @p, "$_ -> $w{$_}\n" for sort { $w{$b} <=> $w{$a} } 
		grep { 5 < length }
		keys %w;

	print @p[0..30];
