#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $n = <>;
chomp $n;

@_ = <>;

print $n - @_ - 1;
