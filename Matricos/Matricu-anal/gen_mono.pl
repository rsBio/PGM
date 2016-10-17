#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $p = 1;
my $fill = 0;
my ($x, $y) = (20, 20);

for (@opt){
	/-p(\d)/ and do {
		$p = $1;
	};
	/-x(\d+)/ and do {
		$x = $1;
	};
	/-y(\d+)/ and do {
		$y = $1;
	};
	/-xy(\d+)/ and do {
		$x = $y = $1;
	};
	/-(w|b)/ and do {
		$fill = $1 eq 'w' ? 0 : 1;
		$p == 2 and 
			$fill = $1 eq 'w' ? 255 : 0;
	};
	/-f(\d+)/ and do {
		$p == 1 and $1 > 1 and die "$0: Can't fill P1 with grey :$!\n"; 
		$fill = $1;
	};
	/-d/ and $debug = 1;
}

print "P$p\n";
print "$x $y\n";
$p == 2 and print "255\n";

for (1 .. $y){
	print join ' ' x ($p - 1), ($fill) x $x;
	print "\n";
}

