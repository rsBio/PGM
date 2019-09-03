#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my @alfabet = split ' ', <>;
my $len = <>;
chomp $len;

my $prep = ',';

$_ = ( $prep . join '', @alfabet ) x $len;

my $re = "${prep}.*([^${prep}]).*" x $len;

my @ans;

/
	^ $re $
	(?{ push @ans, join '', map { eval "\$$_" } 1 .. $len })
	(*F)
	/x;

print for sort @ans;
