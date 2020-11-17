#!/usr/bin/perl

use warnings;
use strict;

$_ = do { local $/; <> };

s/Atvykimas\s*//g;
s/per\s\S+\sval\.\s//g;
s/atvykimas: //g;
s/pa.*puolim.*\s//g;
s/falanga\K.*//g;
s/p.*kuoka\K.*//g;
s/legionierius\K.*//g;
s/(.*)\n(.*)\satakuoja/${1} [žaidėjas]${2}[\/žaidėjas] atakuoja/g;
s/\((.*)\)/[x|y]${1}[\/x|y]/g;

print