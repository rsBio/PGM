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
		$regex =~ y///cs;
		my @Qregex = map quotemeta, split //, $regex;
		
		my $symbols = join '', map {
			"$_+?"
			} @Qregex;
		
		my @coords;
		
		while( $target =~ /${symbols}/g ){
			my $pos = $-[0];
			my $len_of_match = length $&;
			push @coords, join '-', $pos, $pos + $len_of_match - 1;
			$overlap and pos( $target ) = $pos + 1;
			}
		
		$debug and print "regex: /${symbols}/\n";
		print "total: ", ~~ @coords, "\n";
		$debug and print map "$_\n", join " ", @coords;
		}
	
}
