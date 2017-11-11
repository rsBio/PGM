#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $horizontal = 0;
my $split = " ";
my $join = "\t";

for (@opt){
	/-hor/ and do {
		$horizontal = 1;
	};
	/-tsv/ and do {
		$split = '\t';
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
	/-totsv/ and do {
		$join = '\t';
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
	/-d/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = grep m/./, (defined $in ? <$in> : <STDIN>);
	chomp @data;
	
	my $cols = shift @data;
	my @cols;
	my @values = split /$split/, shift @data;
    $debug and print "values: @values\n";
	my @idxs = (0 .. @values - 1);
	my @used;
    
	my $line = '';
	my $width = @values * 3;
	my $width_dec = $width - 3;
	my $j = 0;
	my $k = 0;
	while( (@values * 3 + 1) * $cols != length $line ){
	#	$j ++ > 400 and last;
	#	print "$line\n";
		$k ++;
		$k > 30 * @values and do {
			$k = 0;
		#!	$line =~ s/ *\b\d+$//;
			$line =~ s/^.*\z//m;
		};
		$line .= sprintf "%3s", int rand(@values);
	#	print "$line\n";
		$line =~ s/(\b\d+\b)(.*?)\K *\b\1$// and redo;
		$line =~ s/(\b\d+\b)(?:..{$width})*..{$width_dec}\K *\b\1$//s and redo;
		$line =~ s/.{$width}\K$/\n/ and $k = 0;
	}


	$line =~ s/\d+/$values[$&]/g;
	print $line;
	print '-' x 10 . "\n";

	$line = join ',', split / +/, $line;
	$line =~ s/^\W//gm;
	print $line;
	print '-' x 10 . "\n";
	
	$line =~ s/,/\t/g;
	print $line;
	print '-' x 10 . "\n";
}


