#!/usr/bin/perl

use warnings;
use strict;

srand;

my $n = 15;
my $m = 40;

my $del = 60; # %

##	my $maze = join "\n",
##    	  '┌' . '┬' x ($m -1) . '┐',
##    	( '├' . '┼' x ($m -1) . '┤' ) x ($n -1),
##   	  '└' . '┴' x ($m -1) . '┘'
##    	;

    my $maze = join "\n",
    	  'a' . 'b' x ($m -1) . 'c',
    	( 'd' . 'e' x ($m -1) . 'f' ) x ($n -1),
    	  'g' . 'h' x ($m -1) . 'i'
    	;

my %sym = (
	'a' => '┌', 'b' => '┬', 'c' => '┐',
	'd' => '├', 'e' => '┼', 'f' => '┤',
	'g' => '└', 'h' => '┴', 'i' => '┘',
	);

my $l_maze = length $maze;
my $visible_len = scalar grep m/./, split m//, $maze;
my $to_del = int $visible_len * $del / 100;

print "[$l_maze|$visible_len|$to_del]\n";

my $empty = '+';
while( $to_del ){
	my $index = rand $l_maze;
	"\n" eq substr $maze, $index, 1 and next;
	$empty eq substr $maze, $index, 1 and next;
	substr $maze, $index, 1, $empty; # ╳
	$to_del --;
}

$maze =~ s/\+/ /g;
$maze =~ s/[a-i]/ $sym{ $& } /eg;

print $maze;


print "\n";
