#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $n = <>;
chomp $n;

my $prep = ',';

$_ = ( $prep . join '', 1 .. $n ) x $n;

my $re = "${prep}.*([^${prep}]).*" x $n;

my @perm;

/
	^ $re $
	(?{ push @perm, grep !m!(.).*\1!, join '', map { eval "\$$_" } 1 .. $n; })
	(*F)
	/x;

print ~~ @perm;

print join ' ', split '' for @perm;
