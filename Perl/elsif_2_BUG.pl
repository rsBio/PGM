#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

print 5 . do{ if( "" ){ 5 } elsif( 0 ){ 6 } } . "a"; 
print 5 + scalar do{ if( "" ){ 5 } elsif( 0 ){ 6 } } . "a"; 

my $i = 0;

print 5 . do{ if( "" ){ "A" } elsif( $i ){ "B" } } . "a"; 

