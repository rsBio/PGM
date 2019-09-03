#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

{ local $/; $_ = <> };

s/>.*//;
s/\s//g;

my $complementary = y/ACGT/TGCA/r;

my @ans;

/
	.{4,12}?
	(?{ 
		if( $& eq reverse substr $complementary, ( pos ) - length $&, length $& ){
			push @ans, join ' ', ( pos ) + 1 - length $&, length $&;
			}
		})
	(*F)
	/x;

print for @ans;
