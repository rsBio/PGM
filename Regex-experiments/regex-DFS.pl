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
my $join = " ";
my $pbm = 0;
my $to_pgm = 1;
my $starting_x = 1;
my $starting_y = 1;

for (@opt){
	/-pbm/ and do {
		$pbm = 1;
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

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = grep m/./, (defined $in ? <$in> : <STDIN>);
	chomp @data;
	
	my( $rows, $cols );
	if( $pbm ){
		shift @data;
		( $rows, $cols ) = reverse split ' ', shift @data;
	}
	else{
		( $rows, $cols ) = ( 0 + @data, 0 + split $split, $data[0] );
	}
	
	@data = map { [ split /$split/ ] } @data;
	
	$debug and print "\@data:\n";
	$debug and print "@{$_}\n" for @data;
	$debug and print "-----\n";
	
	( unshift @{ $_ }, 0 ), ( push @{ $_ }, 0 ) for @data;
	unshift @data, [ ( 0 ) x ( $cols + 2 ) ];
	push @data, [ ( 0 ) x ( $cols + 2 ) ];
	
	$debug and print "\@data:\n";
	$debug and print "@{$_}\n" for @data;
	$debug and print "-----\n";
	
	my $max_length = $rows * $cols;
	
	$_ = ( ',' . join '', reverse qw( r d u l ) ) x $max_length;
	
	print " $rows $cols $_\n";
	
	my %dx = ( 'u' => 0, 'd' => 0, 'l' => -1, 'r' => 1, );
	my %dy = ( 'u' => -1, 'd' => 1, 'l' => 0, 'r' => 0, );
	
	my @used;
	
	@used = map [ ( 0 ) x ( $cols + 2 ) ], @data;
	
	my $curr_str = '';
	my @curr_x = ( $starting_x );
	my @curr_y = ( $starting_y );
	my $curr_x = pop @curr_x;
	my $curr_y = pop @curr_y;
	
	/
		^
		(?:
			, \w*(\w)\w*+
		#	(?{ print " $^N" })
			(?:
				(?{ $curr_str .= $^N })
				(?{ print " $curr_str\n" })
				(?{ $curr_x += $dx{ $^N } })
				(?{ $curr_y += $dy{ $^N } })
				(?{ push @curr_x, $dx{ $^N } })
				(?{ push @curr_y, $dy{ $^N } })
				(?{	$used[ $curr_y ][ $curr_x ] += 1 })
				(?{ print " $curr_x|$curr_y\n" })
				|
				(?{ chop $curr_str })
				(?{	$used[ $curr_y[-1] ][ $curr_x[-1] ] -= 1 })
				(?{ $curr_x -= pop @curr_x })
				(?{ $curr_y -= pop @curr_y })
				(*F)
			)
			(?(?{ $curr_x < 1 || $curr_x > $cols }) (*F) )
			(?(?{ $curr_y < 1 || $curr_y > $rows }) (*F) )
			(?(?{ 1 == $data[ $curr_y ][ $curr_x ] }) (*F) )
			(?(?{ 1 < $used[ $curr_y ][ $curr_x ] }) (*F) )
			(?{ print "  @{ $_ }\n" for @used })
			(?{ print "  @{ $_ }\n" for @data })
		#	(?{	$data[ $curr_y ][ $curr_x ] += 2 })
		){$max_length}
	#	(?{ print " $1\n" })
		(*F)
	/x;
	
	
	if( $to_pgm ){
		print "P2\n";
		print $cols, ' ', $rows, "\n";
	#?	print $max_size + $darker, "\n";
	#?	print "@{$_}\n" for @new;
	}
	
#?	if( $to_matrix ){
	#?	print "@{$_}\n" for @new;
#?	}
}
