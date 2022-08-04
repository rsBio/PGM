#!/usr/bin/perl

use warnings;
use strict;
use bigint;

$\ = $/;

<>;

{ local $/ ; $_ = <> };

s/\s//g;

my $AU = () = m/A/g;
my $CG = () = m/C/g;

print eval join '*', map 1 .. $_, $AU, $CG;