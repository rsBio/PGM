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
	/-nosep/ and do {
		$split = '';
	};
	/-d$/ and do {
		$debug = 1;
	};
}

sub SW {
	my @A = @_;
	$debug and print "\@A:[@A]\n";
	my @H;
	my $eq = 3;
	my $W1 = 2;
	
	for my $i ( 0 .. length $A[ 1 ] ){
		$H[ $i ][ 0 ] = 0;
		}
	$H[ 0 ] = [ 0, ( 0 ) x length $A[ 0 ] ];
	
##	$debug and print ">@{$_}\n" for @H;
	
	for my $i ( 1 .. length $A[ 1 ] ){
		for my $j ( 1 .. length $A[ 0 ] ){
			$H[ $i ][ $j ] = ( sort { $b <=> $a } 
				$H[ $i - 1 ][ $j - 1 ] + 
					$eq * ( 0.5 <=> ( substr( $A[ 1 ], $i - 1, 1 ) ne
								   substr( $A[ 0 ], $j - 1, 1 ) 
								 )
						   ),
				( sort { $b <=> $a } 
					map { $H[ $i - $_ ][ $j ] - $_ * $W1 } 1 .. $i - 1 
				)[ 0 ],
				( sort { $b <=> $a } 
					map { $H[ $i ][ $j - $_ ] - $_ * $W1 } 1 .. $j - 1 
				)[ 0 ],
				0,
				)[ 0 ];
			}
		}
	
	my $max = 0;
	my $max_i;
	my $max_j;
	
	for my $i ( 1 .. length $A[ 1 ] ){
		for my $j ( 1 .. length $A[ 0 ] ){
			$H[ $i ][ $j ] > $max and do {
				$max = $H[ $i ][ $j ];
				$max_i = $i;
				$max_j = $j;
				};
			}
		}
	
	my @traceback = ( $max );
	my $first = substr $A[ 1 ], $max_i - 1, 1;
	my $second = substr $A[ 0 ], $max_j - 1, 1;
	my $i = $max_i;
	my $j = $max_j;
	$debug and print "i,j:[$i $j]\n";
	
	while( $H[ $i - 1 ][ $j - 1 ] != 0 ){
		my $ref = 
		( sort { $b->[ 0 ] <=> $a->[ 0 ] }
			map { 
				[ $H[ $i - $_->[ 0 ] ][ $j - $_->[ 1 ] ], @{ $_ } ] 
				} [ 1, 1 ], [ 1, 0 ], [ 0, 1 ] 
		)[ 0 ];
		
		push @traceback, $ref->[ 0 ];
		$i -= $ref->[ 1 ];
		$j -= $ref->[ 2 ];
		$ref->[ 1 ] or do { chop $first ; $first  .= '-'; };
		$ref->[ 2 ] or do { chop $second; $second .= '-'; };
		$first  .= substr $A[ 1 ], $i - 1, 1;
		$second .= substr $A[ 0 ], $j - 1, 1;
		}
	
	$debug and print map { map ">>$_\n", join ' ', map { sprintf "%.2f", $_ } @{$_} } @H;
	$debug and print "\@traceback:[@traceback]\n";
	
	return scalar( reverse $first ), scalar( reverse $second );
	}

for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split ] } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	print map "$_\n", join "\n", SW( @{$_} ) for @data;
}
