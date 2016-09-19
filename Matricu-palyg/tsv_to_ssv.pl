#!/usr/bin/perl

use strict;
use warnings;

$\ = $/;

my @data = map { chomp; [ split /\t/ ] } <>;

#%  print 0 + @data, " x ", join ' ', map { 0 + @{$_} } @data;

shift @data;
shift @{$_} for @data;

print join ' ', @{$_} for @data;
