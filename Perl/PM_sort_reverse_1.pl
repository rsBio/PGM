#!/usr/bin/perl

# used for: https://perlmonks.org/?node_id=11129169

use warnings;
use strict;

$\ = $/;

sub sort_sub{
	return $a cmp $b;
	}

sub some_sub{
	my $ref = shift;
	print "@{ $ref }";
	
	for my $i ( 0 .. @{ $ref } - 2 ){
		$ref->[ $i ] cmp $ref->[ $i + 1 ] and do { ;;; };
	}
}

my @original = ( 5, 'A' .. 'C', 0, 4 );
my @sorted = sort sort_sub @original;
my @r_sorted = reverse @sorted;

some_sub( $_ ) for \@original, \@sorted, \@r_sorted;
print '-';

some_sub( [ sort { $_ * sort_sub } @original ] ) for 0, 1, -1;
print '-';

my @reversed = reverse @original;

some_sub( $_ ) for \@original, \@reversed;
print '-';

some_sub( [ sort { $_ }  @original ] ) for 0, 1, -1;

###########

srand 1;

my $show_distance = 10;

for my $length ( 1 .. 3 ** 3 - 1, 
				map { 3 ** $_, 3 ** $_ + 1 } 3 .. 10,
				){
	print join " length: $length ", ( '=' x 5 ) x 2;
	
	my $test = [ map int rand 10, 1 .. $length ];
	
	my %sub = (
		'$a <=> $b' => { 'sub' => sub { $a <=> $b } },
		'0' => { 'sub' => sub { 0 } },
		'1' => { 'sub' => sub { 1 } },
		'-1' => { 'sub' => sub { -1 } },
		);
	
	for my $key ( sort keys %sub ){
		my $count = 0;
		$sub{ $key }{ 'array' } = 
			[ sort { $count ++; $sub{ $key }{ 'sub' }->() } @{ $test } ];
		$sub{ $key }{ 'count' } = $count;
		}
	
	for my $key ( sort keys %sub ){
		print "\$key:[$key]";
		print " count:[$sub{ $key }{ 'count' }]";
		my $len = @{ $sub{ $key }{ 'array' } };
		printf " array:[%s ... %s]\n",
			( join ' ', @{ $sub{ $key }{ 'array' } }[ 
				grep { 0
					|| $show_distance > abs( $_ - 0 )
					} 0 .. $len - 1
				] ),
			( join ' ', @{ $sub{ $key }{ 'array' } }[ 
				grep { 0
					|| $show_distance > abs( $_ - $len + 1 )
						&& not $show_distance > abs( $_ - 0 )
					} 0 .. $len - 1
				] ),
			;
		}
	
	print "key='1' NOT EQUAL to reverse!" if "@{ $sub{ 1 }{ 'array' } }"
		ne join ' ', reverse @{ $test };
	
	print "key='-1' NOT EQUAL to key='0'!" if "@{ $sub{ -1 }{ 'array' } }"
		ne "@{ $sub{ 0 }{ 'array' } }";
	
	print '';
	}
