#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

{ local $/; $_ = <> }

( undef, @_ ) = split /\>/;

s/.*// for @_;
s/\s//g for @_;

$debug and print "\@_: $_" for @_;

my @matrix;

for my $i ( 0 .. ( length $_[ 1 ] ) - 1 ){
	my $letter_at_i = substr $_[ 1 ], $i, 1;
	
	my @row;
	
	while( $_[ 0 ] =~ /./g ){
		push @row, 0 + !!( $& eq $letter_at_i );
		}
	
	push @matrix, [ @row ];
	}

$debug and print "  ", join " ", split //, $_[ 0 ];
$debug and print "$& @{ $matrix[ ( pos $_[ 1 ] ) - 1 ] }" while $_[ 1 ] =~ /./g;

unshift @matrix, [ ( 0 ) x length $_[ 0 ] ];
unshift @{ $_ }, 0 for @matrix;

$debug and print "    ", join " ", split //, $_[ 0 ];
$debug and print "  ", join " ", @{ $matrix[ 0 ] };
$debug and print "$& @{ $matrix[ ( pos $_[ 1 ] ) - 0 ] }" while $_[ 1 ] =~ /./g;

my @copy_matrix;
push @copy_matrix, [ @{ $_ } ] for @matrix;

for my $i ( 1 .. ( length $_[ 1 ] ) - 0 ){
	for my $j ( 1 .. ( length $_[ 0 ] ) - 0 ){
		my( $max ) = sort { $b <=> $a }
			$matrix[ $i - 1 ][ $j ], 
			$matrix[ $i - 1 ][ $j - 1 ], 
			$matrix[ $i ][ $j - 1 ];
		if( $matrix[ $i ][ $j ] == 0 ){
			$matrix[ $i ][ $j ] += $max;
			}
		else{
			$matrix[ $i ][ $j ] += $matrix[ $i - 1 ][ $j - 1 ];
			}
		}
	}

$debug and print "    ", join " ", split //, $_[ 0 ];
$debug and print "  ", join " ", @{ $matrix[ 0 ] };
$debug and print "$& @{ $matrix[ ( pos $_[ 1 ] ) - 0 ] }" while $_[ 1 ] =~ /./g;

my @LCSQ;

for my $i ( 1 .. ( length $_[ 1 ] ) - 0 ){
	for my $j ( 1 .. ( length $_[ 0 ] ) - 0 ){
		$matrix[ $i ][ $j ] *= $copy_matrix[ $i ][ $j ];
		
		$LCSQ[ $matrix[ $i ][ $j ] ] //= substr $_[ 1 ], $i - 1, 1;
		}
	}

$debug and print "    ", join " ", split //, $_[ 0 ];
$debug and print "  ", join " ", @{ $matrix[ 0 ] };
$debug and print "$& @{ $matrix[ ( pos $_[ 1 ] ) - 0 ] }" while $_[ 1 ] =~ /./g;

shift @LCSQ;
print @LCSQ;


__END__
unused:

		my $direction = $max == $matrix[ $i - 1 ][ $j - 1 ] ? 
			[ -1, -1 ] : $max == $matrix[ $i - 1 ][ $j - 0 ] ? [ -1, 0 ] : [ 0, -1 ];
		$directions[ $i ][ $j ] = $direction;
		
my $now = [ ( length $_[ 1 ] ) - 0, ( length $_[ 0 ] ) - 0 ];

my $LCSQ = '';

while( 1 ){
#!!	$LCSQ .= ( substr $_[ 1 ], $now->[ 0 ] - 1, 1 ) eq ( substr $_[ 0 ], $now->[ 1 ] - 1, 1 ) && $matrix[ ][ ] ? ( substr $_[ 1 ], $now->[ 0 ] - 1, 1 ) : '';
	$debug and print " LCSQ: [$LCSQ]";
	
	last if not defined $directions[ $now->[ 0 ] ][ $now->[ 1 ] ];
	
	print "@{ $directions[ $now->[ 0 ] ][ $now->[ 1 ] ] } | @{ $now }";
	
	$now = [ $now->[ 0 ] + $directions[ $now->[ 0 ] ][ $now->[ 1 ] ][ 0 ], 
			$now->[ 1 ] + $directions[ $now->[ 0 ] ][ $now->[ 1 ] ][ 1 ] ];
	
	$debug and print "\@now: [@{ $now }]";
	}

print $LCSQ;
