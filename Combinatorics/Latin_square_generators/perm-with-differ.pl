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
    
    push @used, [ (0) x @values ] for 1 .. @values;
    $debug and print "[@{$_}]\n" for @used;
	
	$cols > @values 
		and die "$0: Num of columns ($cols) > num of values (", 0 + @values, "):$!\n";
	
	my $cnt;
	my @cnt;
	my $seed;
#	$seed = time ^ ($$ + ($$ << 15));
	$seed = int(rand(2**31));
	
	for (1 .. $cols - ($cols == @values) ){
		
		$cnt ++;
		$cnt % (1 + rand(1e5)) or srand($seed);
		my @try = fisher_yates_shuffle( @idxs );
    #%   $debug and print "try: @try\n";
		my $f = 0;
		my $i = 0;
		map {
			$f += $used[$_][$i];
			$i ++;
		} @try;
		
	#%	$debug and print "F: $f\n";
		
		$f and redo;

	#%	$debug and print "cnt: $cnt\n";
		push @cnt, $cnt;
		
		$i = 0;
		map {
			$used[$_][$i] = 1;
			$i ++;
		} @try;

		push @cols, [ @try ];
        
        $debug and print "[@{$_}]\n" for @used;
		$debug and print map { ":@{$_}\n" } @cols;
		$debug and print "cnt: @cnt\n";
	}
		
	if( $cols == @values ){
		my @try;
		
		for my $i (0 .. @values - 1){
			for my $j (0 .. @values - 1){
				$used[$i][$j] or $try[ $j ] = $i;
			}
		}
		push @cols, [ @try ];

        $debug and print "--cols == values--\n";
		$debug and print map { ":@{$_}\n" } @cols;
	}

	$debug and print "-" x 10, "\n";
	$debug and print map "$_\n", join "\t", 0 .. @values - 1;
	$debug and print map "$_\n", join "\t", @values;
	$debug and print "cnt: @cnt\n";
	$debug and print "-" x 10, "\n";

	if( $horizontal ){
		print map { "$_\n" } map { join "$join", map { $values[$_] } @{$_} } @cols;
	}
	else {
		while( @{ $cols[0] } ){
			print join "$join", map { $values[$_] } map { shift @{$_} } @cols;
			print "\n";
		}
	}
}

#--- perlmonks:

    # fisher_yates_shuffle( \@array ) : 
    sub fisher_yates_shuffle {
        my @array = @_;
        my $i;
        for ($i = @array; --$i; ) {
            my $j = int rand ($i+1);
            next if $i == $j;
            @array[$i,$j] = @array[$j,$i];
        }
		@array;
    }

