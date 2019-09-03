#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

my @alphabet = split ' ', <>;
my $len = <>;
chomp $len;

my $alphabet = join '', @alphabet;

my @sorted_alphabet = sort @alphabet;

my %h;
my %g;

$alphabet =~ /
	.
	(?{ $g{ $sorted_alphabet[ ( pos ) - 1 ] } = $&; })
	(*F)
	/x;

my $prep = ',';

$_ = ( $prep . join '', @alphabet ) x $len;

my $re = "${prep}[^${prep}]*?([^${prep}])?[^${prep}]*+" x $len;

$debug and print;
$debug and print $re;

my %ans;

/
	^ $re $
	(?{ $ans{ join '', grep length, map { eval "\$$_" } 1 .. $len } ++ })
	(*F)
	/x;

delete $ans{ '' };

print for map { s/./$g{ $& }/gr } sort keys %ans;
