#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $split = "";

for (@opt){
	/-tsv/ and do {
		$split = "\t";
	};
	/-csv/ and do {
		$split = ',';
	};
	/-cssv/ and do {
		$split = ', ';
	};
	/-ssv/ and do {
		$split = ' ';
	};
	/-d/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = grep m/./, (defined $in ? <$in> : <STDIN>);
    
	my ($rows, $cols) = split ' ', $data[ 0 ];
	my $area = $rows * $cols;
	
	$debug and print "Area: $area ($rows x $cols)\n";
	my $ok = 1;
	my $eq = 0;
	$ok = 0, print "Wide of matrix != number of columns!\n" if 
		$rows != ($eq = grep { $_ == $cols } map { length $data[ $_ ] =~ s/\n//r } 1 .. $rows);
	$debug and print "Rows: $rows, Eq: $eq\n";

	my $n = $data[ $rows + 1 ];
	my $cnt_let = 0 + eval join '+', map { length $data[$rows + 1 + $_] =~ s/\n//r } 1 .. $n;
	$ok = 0, print "Area of letter matrix != num of all letters in all words!\n" if
		$area != $cnt_let;
	$debug and print "All letters in all words: $cnt_let\n";

	print $ok ? "Data is OK.\n" : "Data is WRONG.\n";
}
