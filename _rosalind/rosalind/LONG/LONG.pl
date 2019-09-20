#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

$\ = $/;

my $debug = 0;

{ local $/; $_ = <>; }

( undef, @_ ) = split /\>/;

s/.*// for @_;
s/\n//g for @_;

$debug and print for @_;

my @pairs;

my $number_of_lasts = 0;

for my $i ( 0 .. @_ - 1 ){
	my $len = length $_[ $i ];
	
	my $tail = substr $_[ $i ], ( $len >> 1 ) - 1 + $len % 2;
	
	my $new_pairs = 0;
	
	for my $j ( 0 .. @_ - 1 ){
		next if $i == $j;
		
		$_[ $j ] =~ /$tail/ or next;
		my $longer_tail = $` . $tail;
		$_[ $i ] =~ /$longer_tail$/ or next;
		
		push @pairs, [ $i, $j ];
		$new_pairs ++;
		}
	
	$new_pairs > 1 and print "Warning: number of new pairs ($new_pairs) is more than 1!";
	$new_pairs == 0 and $number_of_lasts ++;
	
	$debug and print "new pairs: [$new_pairs]";
	}

$number_of_lasts != 1 and print "Warning: number of lasts ($number_of_lasts) is not equal to 1!";

$debug and print "@{ $_ }" for @pairs;

my %links;

$links{ $_->[ 0 ] } = $_->[ 1 ] for @pairs;

$debug and print "keys: ", join ', ', keys %links;
$debug and print "values: ", join ', ', values %links;

my %values_of_links = map { $_ => 1 } values %links;

my( $start ) = grep { not $values_of_links{ $_ } } 0 .. @_ - 1;

$debug and print "start: [$start]";

my $key = $start;

my @sequence;

while( exists $links{ $key } ){
	push @sequence, $key;
	$key = $links{ $key };
	}

push @sequence, $key;

$debug and print "sequence: [@sequence]";

$_ = join ',', @_[ @sequence ];

$debug and print;

s/ ([^,]*) , (?= \1 ) //xg;

print;
