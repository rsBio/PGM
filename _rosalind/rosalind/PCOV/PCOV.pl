#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

@_ = <>;
chomp @_;

my %h;

for( @_ ){
    m/(.)(.+)(.)/;
    $h{ $1 . $2 } = $2 . $3;
    }

my( $next ) = sort keys %h;

my $chromosome = $next;

my %used;

while( $used{ $next } ++ < 1 ){
    $next = $h{ $next };

    $chromosome .= ( split '', $next )[ -1 ];
    }

print substr $chromosome, 0, @_;
