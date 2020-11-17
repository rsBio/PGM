#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

{ local $/; $_ = <> }

( undef, @_ ) = split /\>/;

s/.*// for @_;
s/\s//g for @_;

$debug and print "\@_: $_"for @_;

my %reads;

map { $reads{ $_ } ++; $reads{ reverse_complement( $_ ) } ++ } @_;

$debug and print "reads: $_" for sort keys %reads;

my %orig = map { $_ => 1 } grep { $reads{ $_ } > 1 } sort keys %reads;

$debug and print "orig: $_" for sort keys %orig;

my @corrections;

for( @_ ){
	if( exists $orig{ $_ } or exists $orig{ reverse_complement( $_ ) } ){
		;
		}
	else{
		my @matches;
		while( /./g ){
			for my $letter ( qw( A C G T ) ){
				my $try = $` . $letter . $';
				exists $orig{ $try } and push @matches, $try;
				}
			}
		if( @matches != 1 ){
			print "Warning: read matched not once! [$_] matched to [@matches].";
			}
		push @corrections, "${_}->$matches[ 0 ]";
		}
	}

print for @corrections;

sub reverse_complement {
	my $str = shift;
	$str =~ y/ACGT/TGCA/;
	scalar reverse $str;
	}
