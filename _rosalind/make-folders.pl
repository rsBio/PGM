#!/usr/bin/perl

use warnings;
use strict;

# USE: perl make-folders <word> <list>
# e.g. word: 'rosalind'; e.g.list: 'problem-list.txt'

my $debug = 1;

chomp(
	my( $folder, $list ) = @ARGV
);

open my $List , '<', "$list" or die "$0:Can't create:$!\n";

mkdir $folder or die "$0:Can't mkdir:$!\n";
chdir $folder;

my @lines = <$List>;

$debug and print "[@lines]\n";

my %status = (
	0 => 'not',
	1 => 'ok',
);

while( @lines ){
	my( $acronym, $title, $times_solved, undef, $questions, $solutions, $explanation ) = 
		map { join ' ', split } split "\t", join '', shift @lines, shift @lines;
	
	my $is_solved;
	
	$is_solved = ( $questions && $solutions && $explanation ) ? 1 : 0;
	
	$debug and print join " + ", $acronym, $title, $is_solved, $questions, $solutions, $explanation;
	$debug and print "\n";
	
	mkdir $acronym or die "$0:Can't mkdir:$1\n";
	chdir $acronym;
	
	open my $fh_title, '>',		"${title}.txt" or die "$0:Can't create:$!\n";
	open my $fh_status, '>',	'status.txt' or die "$0:Can't create:$!\n";
	open my $fh_status_2, '>',	'status_2.txt' or die "$0:Can't create:$!\n";
	open my $fh_input, '>',		'sample.in' or die "$0:Can't create:$!\n";
	open my $fh_output, '>',	'sample.out' or die "$0:Can't create:$!\n";
	open my $fh_code, '>',		"${acronym}.pl" or die "$0:Can't create:$!\n";
	
	print $fh_status $status{ $is_solved };
	print $fh_status_2 'not';
	print $fh_title $title;
	chdir '..';
}


