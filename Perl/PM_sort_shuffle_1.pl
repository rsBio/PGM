#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

srand 1;
$ENV{PERL_HASH_SEED} = 0;


# https://perlmonks.org/?node_id=1905
# randomly permutate @array in place
my $fisher_yates_shuffle = sub
{
    my $array = shift;
    my $i = @$array;
    while ( --$i )
    {
        my $j = int rand( $i+1 );
        @$array[$i,$j] = @$array[$j,$i];
    }
};

my $pseudoshuffle_with_sort = sub {
	my( $ref_array ) = shift;
	
	@{ $ref_array } = sort { 0.5 <=> rand } @{ $ref_array };
	};

# https://perlmonks.org/?node_id=11129748
my $pseudoshuffle_with_hash = sub {
	my( $ref_array ) = shift;
		
	@{ $ref_array } = keys %{ {map { $_ => undef } @{ $ref_array }} };
	};


my $size_of_array = 9;

my $A = 'A';
my @array = map { $A ++ } 1 .. $size_of_array;

my $times = 10000;

my @distribution;

@distribution = &distribution_of_occurrences( \@array, 
	$pseudoshuffle_with_sort, $times );

&pretty_squeeze( \@distribution, \@array );
print for '1)', @distribution;

@distribution = &distribution_of_occurrences( \@array, 
    $fisher_yates_shuffle, $times );

&pretty_squeeze( \@distribution, \@array );
print for '2)', @distribution;

@distribution = &distribution_of_occurrences( \@array, 
    $pseudoshuffle_with_hash, $times );

&pretty_squeeze( \@distribution, \@array );
print for '3)', @distribution;


sub distribution_of_occurrences{
	my( $ref_array, $shuffle_sub, $times ) = @_;
	
	my @distribution;
	
	for my $i ( 1 .. $times ){
		
		my @copy_of_array = @{ $ref_array };
		$shuffle_sub->( \@copy_of_array );
		
		my $j = 0;
		map { $distribution[ $j ++ ] .= " " . $_ } @copy_of_array;
		}

	return @distribution = map { 
		join ' ', sort { length $a <=> length $b || $a cmp $b } split 
		} @distribution;
}

sub pretty_squeeze{
	my( $ref_distribution, $ref_array ) = @_;
	
	my $times_approx = split ' ', $ref_distribution->[ 0 ];
	my $del_times = int $times_approx / @{ $ref_array } / 4;

	s/(\b\w+\b) \K (?:[ ]\1){0,$del_times}//xg for @{ $ref_distribution };
	
	my $k = -1;
	my $rx_every_second = join '|', grep $k ++ % 2 == 0, @{ $ref_array };
	s/\b(?:$rx_every_second)\b/./g for @{ $ref_distribution };
	}
