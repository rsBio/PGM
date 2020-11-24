#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @FILES;
my @opt;

for( @ARGV ){
	/^-\S/ ? ( push @opt, $_ ) : ( push @FILES, $_ );
}

my $split = " ";
my $join = " ";
my $starting_pos = 1;
my $rarefy = 1;

for( @opt ){
	/-starting-pos(\d+)/ and do {
		$starting_pos = $1;
	};
	/-rarefy(\d+)/ and do {
		$rarefy = $1;
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
	/-totsv/ and do {
		$join = "\t";
	};
	/-tocsv/ and do {
		$join = ',';
	};
	/-tocssv/ and do {
		$join = ', ';
	};
	/-tossv/ and do {
		$join = ' ';
	};
	/-tonosep/ and do {
		$join = '';
	};
	/-d$/ and $debug = 1;
}

for( @FILES ){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	
	my @data = map { chomp; [ split $split ] } grep m/./, ( defined $in ? <$in> : <STDIN> );
	
	$debug and print "@{ $_ }\n" for @data;
	
	splice @{ $_ }, 0, $starting_pos - 1, () for @data;
	
	my $new_wide = @{ $data[ 0 ] };
	
	my @indexes = grep { $_ <= $new_wide - 1 } map { $_ * $rarefy } 0 .. $new_wide - 1;
	
	$debug and print "\@indexes: @indexes\n";
	
	@{ $_ } = @{ $_ }[ @indexes ] for @data;
	
	print map "$_\n", join $join, @{ $_ } for @data;
}
