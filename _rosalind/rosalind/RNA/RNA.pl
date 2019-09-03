#!/usr/bin/perl

use warnings;
use strict;

{ local $/ ; $_ = <> };

y/T/U/;

print;
