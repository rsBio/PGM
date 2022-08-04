#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

@_ = <>;
chomp @_;

my %h;

map $h{ $_ } = 1, @_;

map $h{ scalar reverse y/ACGT/TGCA/r } = 1, @_;

@_ = sort keys %h;

s/(.)(.+)(.)/($1$2, $2$3)/g for @_;

print join "\n", @_;
