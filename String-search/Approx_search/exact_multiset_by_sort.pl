#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @FILES;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @FILES, $_);
}

my $split = " ";
my $overlap = 0;

for (@opt){
	/-o(?:verlap)?/ and do {
		$overlap = 1;
	};
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
	/-nosep/ and do {
		$split = '';
	};
	/-d$/ and do {
		$debug = 1;
	};
}

my $target;

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; $_ } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
		
	if( not defined $target ){
		$target = join "", @data;
		next;
		}
	
	for my $regex ( @data ){
		my $len_of_regex = length $regex;
		my $sorted_regex = join '', sort split //, $regex;
		
		my @coords;
		
		while( $target =~ /.{$len_of_regex}/g ){
			my $pos = $-[0];
			my $sorted_match = join '', sort split //, "$&";
			$debug and print "[$sorted_match eq $sorted_regex]\n";
			$sorted_match eq $sorted_regex and
				push @coords, join '-', $pos, $pos + $len_of_regex - 1;
			$overlap and pos( $target ) = $pos + 1;
			}
		
		$debug and print "regex:[$regex]\n";
		print "total: ", ~~ @coords, "\n";
		$debug and print map "$_\n", join " ", @coords;
		}
	
}
