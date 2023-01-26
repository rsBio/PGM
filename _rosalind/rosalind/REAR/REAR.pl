#!/usr/bin/perl

# Too slow...

use warnings;
use strict;

$\ = $/;

my $debug = 1;
my $debug2 = 0;

my @ans;

while(<>){
	$debug and print "-" x 15;
	
	my @A = split;
	my @B = split ' ', <>;
	<>;
	
	s/\d+/$& - 1/eg for @A, @B;
	
	@_ = ();
	while( @A ){
		push @_, [ shift @A, shift @B ];
		}
	
	@_ = map $_->[ 1 ], sort { $a->[ 0 ] <=> $b->[ 0 ] } @_;
	
	$debug and print "[@_]";
	
	$_ = join '', @_;
	
	my %used;
	
	my @cand;
	
	push @cand, [ $_, 0 ];
	
	my $min = @_;
	
	while( @cand ){
		my( $str, $depth ) = @{ pop @cand };
		
		next if defined $used{ $str } and $used{ $str } < $depth;
		print "$used{ $str } < $depth" if defined $used{ $str } and $used{ $str } != $depth;
		$used{ $str } = $depth;
		
		next if $depth >= @_;
		
		my $_2;
		
		$debug2 and print "cand:[", 0 + @cand, "],str:[$str]";
		
		0 while 0
			or $str =~ s/(.)((??{ $1 + 1 }))((??{ $1 + 2 }))/$1$3/ and
				$_2 = $2 and
				$str =~ s/(.)(??{ $1 > $_2 ? '' : '(*FAIL)' })/ $1 - 1 /ge
			or $str =~ s/(.)((??{ $1 - 1 }))((??{ $1 - 2 }))/$1$3/ and
				$_2 = $2 and
				$str =~ s/(.)(??{ $1 > $_2 ? '' : '(*FAIL)' })/ $1 - 1 /ge
			;
		
	#	$debug and print "cand:[", 0 + @cand, "],str:[$str],depth:[$depth]";
	#	$debug and print "used:[$used{ $str }]";
		
		$debug2 and print map "[$_]", join ' ', map $_->[0], @cand;
		
		if( $str eq '01' or $str eq '10' ){
			if( $str eq '10' ){
				$depth ++;
				}
			$depth < $min and $min = $depth;
			next;
			}
		
		for my $i ( 0 .. -1 + length $str ){
			my $ip = $i + 1;
			my $im = $i - 1;
			if( $str =~ m/(.*) $i (.+) $ip (.*)/x and $i < length $str ){
				$debug2 and print "$i:[$1($i)$2($ip)$3]";
				$debug2 and print $1 . $i . $ip . ( reverse $2 ) . $3;
				$debug2 and print $1 . ( reverse $2 ) . $i . $ip . $3;
				push @cand,
					[ $1 . $i . $ip . ( reverse $2 ) . $3, $depth + 1 ],
					[ $1 . ( reverse $2 ) . $i . $ip . $3, $depth + 1 ],
					;
				}
			if( $str =~ m/(.*) $i (.+) $im (.*)/x ){
				$debug2 and print "$i:[$1($i)$2($im)$3]";
				$debug2 and print $1 . $i . $im . ( reverse $2 ) . $3;
				$debug2 and print $1 . ( reverse $2 ) . $i . $im . $3;
				push @cand,
					[ $1 . $i . $im . ( reverse $2 ) . $3, $depth + 1 ],
					[ $1 . ( reverse $2 ) . $i . $im . $3, $depth + 1 ],
					;
				}
			}
		}
	
	$debug and print "min:[$min]";
	push @ans, $min;
	}

print "@ans";