#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

while( my $n = <> ){
	$debug and print '-' x 15;
	
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
	
	$debug and print ~~ @perm;
	
	$debug and print join ' ', split '' for @perm;
	
	my @minuses;
	
	for my $i ( 0 .. 2 ** $n - 1 ){
		push @minuses, join ' ', split //, sprintf "%0${n}b", $i;
		}
	
	my @perm_with_minuses;
	
	for my $perm ( @perm ){
		for my $minuses ( @minuses ){
			my @p = split //, $perm;
			my @m = split ' ', $minuses;
			for my $i ( 0 .. $n - 1 ){
				$p[ $i ] *= -1 if $m[ $i ];
				}
			push @perm_with_minuses, join ' ', @p;
			}
		}
	
	$debug and print @perm * 2 ** $n;
	
	print ~~ @perm_with_minuses;
	print for @perm_with_minuses;
	}