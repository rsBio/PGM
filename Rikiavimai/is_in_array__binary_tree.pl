#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;
    
my $debug = 0;

my @FILES;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @FILES, $_);
}

my $split = " ";
my $find;

for (@opt){
	/-find(\d+)/ and do {
		$find = $1;
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

sub is_in_array__primitive {
	$find //= shift;
	my $found;
	
#	$find == $_ and ++ $found for @_;
	$found = grep $_ == $find, @_;
	
	return $found ? "TRUE" : "FALSE";
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", join ' ', is_in_array__primitive( @{$_} ) for @data;
}
