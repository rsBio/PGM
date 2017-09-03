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
my $to_pbm = 0;
my $to_pgm = 0;

for (@opt){
	/-topbm/ and do {
		$to_pbm = 1;
	};
	/-topgm/ and do {
		$to_pgm = 1;
	};
	/-d$/ and $debug = 1;
}

for (1){
	
	my @field;
	
	my $n = 20;
	my $m = 30;
	
	for my $i ( 1 .. $n ){
		push @field, [ ( 0 ) x $m ];
		}
	
	my $objects = 10;
	
	for my $i ( 1 .. $objects ){
		my $rn = rand( $n / 2);
		my $rm = rand( $m );
		if( $field[ $rn ][ $rm ] == 0 ){
			$field[ $rn ][ $rm ] = 1;
			}
		else {
			redo;
			}
		}
	
	for my $i ( 1 .. $objects / 3 ){
		my $rn = $n / 2 + rand( $n / 2);
		my $rm = rand( $m / 4 );
		if( $field[ $rn ][ $rm ] == 0 ){
			$field[ $rn ][ $rm ] = 1;
			}
		else {
			redo;
			}
		}
	
	for my $i ( 1 .. $objects / 3 ){
		my $rn = $n / 2 + rand( $n / 2);
		my $rm = $m * 3 / 4 + rand( $m / 4 );
		if( $field[ $rn ][ $rm ] == 0 ){
			$field[ $rn ][ $rm ] = 1;
			}
		else {
			redo;
			}
		}
	
	for my $i ( 1 .. $n - 1 ){
		for my $j ( 0 .. $m - 1 ){
			$field[ $i - 0 ][ $j ] == 1 and 
			$field[ $i - 1 ][ $j ] == 1 and 
			$field[ $i - 0 ][ $j ] = 0;
			}
		}
	
	my $cnt = grep /1/, map { @{ $_ } } @field;
	
#	print STDERR $cnt;
	
	my %ans;
	
	my $kp = 0;
	
	while( $kp != 6 ){
		for my $i ( 1 .. $n - 1 ){
			$kp == 6 and last;
			for my $j ( 0 .. $m - 1 ){
				$field[ $i - 0 ][ $j ] == 0 and 
				$field[ $i - 1 ][ $j ] == 1 or next;
				1 > rand( $cnt ) or next;
				$field[ $i - 0 ][ $j ] = 2;
				$ans{ $i - 1 }{ $j } = 1;
				$kp ++;
				$kp == 6 and last;
				}
			}
		}
	
	my $zkp = 0;
	
	while( $zkp != 5 ){
		for my $i ( 1 .. $n - 1 ){
			$zkp == 5 and last;
			for my $j ( 0 .. $m - 1 ){
				$field[ $i ][ $j ] != 1 and next;
				1 > rand( $cnt ) or next;
				$ans{ $i }{ $j } = 1;
				$zkp ++;
				$zkp == 5 and last;
				}
			}
		}
	
#	print STDERR 0 + map { keys %{ $ans{ $_ } } } keys %ans;
	
	my $flat = 10;
	
	my @flat_field = @field;
	$_ = [ ( 0 ) x $flat , @{ $_ }, ( 0 ) x $flat ] for @flat_field;
	unshift @flat_field, [ ( 0 ) x ( $flat * 2 + $m ) ] for 1 .. $flat;
	push @flat_field, [ ( 0 ) x ( $flat * 2 + $m ) ] for 1 .. $flat;
	
	print STDERR @{ $_ }, "\n" for @flat_field;
	
	my $window_R = $flat;
	
	for my $i ( 1 .. 5 ){
		my @keys1 = keys %ans;
		my $key1 = $keys1[ rand( @keys1 ) ];
	#	print STDERR $key1, "\n";
	#	print STDERR map ":$_\n", join ' ', keys %{ $ans{ $key1 } };
		my @keys2 = keys %{ $ans{ $key1 } };
		my $key2 = $keys2[ 0 ];
		print STDERR ": $key1 $key2\n";
		my( $flat_key1, $flat_key2 ) = map { $_ += $flat } $key1, $key2;
		my @tsk_field;
		push @tsk_field, [ @{ $_ } ] for @flat_field;
		
		for my $coords ( 
				[ -1, -2 ],
				[  0, -2 ],
				[  1, -2 ],
				
				[  2, -1 ],
				[  2,  0 ],
				[  2,  1 ],
				
				[ -1,  2 ],
				[  0,  2 ],
				[  1,  2 ],
				
				[ -2, -1 ],
				[ -2,  0 ],
				[ -2,  1 ],
				){
				$tsk_field[ $flat_key1 + $coords->[0] ][ 
					$flat_key2 + $coords->[1] ]
					= 3;
			}
		
		map { $_ = y/2/0/r } @{ $_ } for @tsk_field;
		
		shift @tsk_field for 1 .. $flat_key1 - $flat;
		pop @tsk_field for $flat_key1 + $flat + 1 .. $n + $flat * 2 - 1;
		
		splice @{ $_ }, $flat_key2 + $flat + 1 for @tsk_field;
		splice @{ $_ }, 0, $flat_key2 - $flat for @tsk_field;
		
		map { $_ = y/0123/9065/r } @{ $_ } for @tsk_field;
		
		open my $tsk_file, '>', "tasks/${i}.pgm" or die "Can't open!\n";
		
		print $tsk_file "P2\n";
		print $tsk_file $flat * 2 + 1, " ", $flat * 2 + 1, "\n";
		print $tsk_file "9\n";
		print $tsk_file map "$_\n", join ' ', @{ $_ } for @tsk_field;
		}
	
	map { $_ = y/0123/9065/r } @{ $_ } for @field;
	
	open my $field_file, '>', "tasks/0.pgm" or die "Can't open!\n";
	
	print $field_file "P2\n$m $n\n9\n";
	print $field_file map "$_\n", join ' ', @{ $_ } for @field;
	
	last;
}
