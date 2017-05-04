#!/usr/bin/perl

use strict;
use warnings;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $split = " ";
my $join = " ";
my $cr = 1;
my $pbm = 0;

for (@opt){
	/-pbm/ and do {
		$pbm = 1;
	};
	/-rc/ and do {
		$cr = 0;
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
	/-d$/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	
	my @data = map { [ split ] } (defined $in ? <$in> : <STDIN>);
	
	if( $pbm ){
		print "P1\n";
		}
	
	print join ' ', ( 0 + @{ $data[0] }, 0 + @data )[ 1 - $cr, $cr - 0 ];
	print "\n";
	
	print map "$_\n", join $join = $split, @{$_} for @data;
}

