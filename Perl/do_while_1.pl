#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $i = 0;

do { print "i:$i" } while ++ $i < 3;

my $j = 0;

not 'TRUE' or do { print "j:$j" } while ++ $j < 3;

my $k = 0;

0, do { print "k:$k" } while ++ $k < 3;
