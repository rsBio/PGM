#!/usr/bin/perl

use warnings;
use strict;

{ local $/ ; $_ = <> };

$\ = $/;

chomp;

y/ACTG/TGAC/;

print scalar reverse;
