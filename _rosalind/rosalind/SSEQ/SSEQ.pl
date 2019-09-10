#!/usr/bin/perl

use warnings;
use strict;
use re qw( eval );

$\ = $/;

my $debug = 0;

{ local $/ ; $_ = <> };

( undef, @_ ) = split /\>/;

for( @_ ){
	chomp;
	my( $id, $nucleotides ) = split ' ', $_, 2;
	$_ = $nucleotides =~ s/\s//gr;
	}

my @pos;

my $re = join '', map ".*?$_(?{ push \@pos, pos })(*SKIP)", split //, $_[ 1 ];

$debug and print "\$_: $_";
$debug and print "re: $re";

$_[ 0 ] =~ /
	^
	$re
	/x;

print "@pos" if @pos == length $_[ 1 ];