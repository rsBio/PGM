#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $split = "\t";
my $join = "\n";
my @cities;
my $arena = 0;
my $xspeed = 1;
my @times;
my $unit;

for (@opt){
	/-c\K((-?\d+),(-?\d+)(,,)?)+/ and do {
		$debug and print "Match 'c': [$&]\n";
		@cities = map { [ split /,/ ] } split /,,/, $&;
	};
	/-a(\d+)/ and do {
		$arena = $1;
	};
	/-x(\d+)/ and do {
		$xspeed = $1;
	};
	/-t([:\d]+),([:\d]+)/ and do {
		@times = ( $1, $2 );
	};
	/-u(?:nit)?(\d+)/ and do {
		$unit = $1;
	};
	/-d$/ and $debug = 1;
}

$debug and print "Option [$_]\n" for @opt;
$debug and print "City [@$_]\n" for @cities;

if( @cities < 3 ){
	if( @cities == 1 ){ unshift @cities, [ 0, 0 ] }
	print "Server speed: x${xspeed}, Arena: ${arena} lvl.\n";
	
	print map "$_\n", join ' => ', map { join '|', @{$_} } @cities;
	my $dist = sqrt( ($cities[0][0] - $cities[1][0]) ** 2 + ($cities[0][1] - $cities[1][1]) ** 2 );
	print "Dist: $dist\n";
	
	my $slow_dist = 20 < $dist ? 20 : $dist;
	my $arena_dist = 20 < $dist ? $dist - 20 : 0;
	$debug and print "Slow-dist: $slow_dist, Arena-dist: $arena_dist\n";
	
	for my $speed ( 1 .. 15 ){
		my $sp = $speed * $xspeed;
	#%	print $dist / $speed, "\n";
		my $time;
		my $slow_time = $slow_dist / $sp;
		my $arena_time = $arena_dist / ( $sp * ( 1 + $arena * 0.1 ) );
		$time = $slow_time + $arena_time;
		my $h = int $time;
		$time = ( $time - $h ) * 60;
		my $m = int $time;
		$time = ( $time - $m ) * 60;
		my $s = int( $time + 0.5 );
		$s == 60 and do { $s = 0; $m ++ };
		$m == 60 and do { $m = 0; $h ++ };
		printf "%2d: ", $speed; 
		print map "$_\n", join ":", map { sprintf "%02d", $_ } $h, $m, $s;
		}
	}
else{
	@times or do { print "Please input times.\n"; exit };
	$unit or do { print "Please input unit speed.\n"; exit };
	print "Server speed: x${xspeed}, Unit-speed: ${unit}.\n";
	
	print map "$_\n", join ' => ', map { join '|', @{$_} } @cities[0, 1];
	print map "$_\n", join ' => ', map { join '|', @{$_} } @cities[0, 2];
	my $dist_01 = sqrt( ($cities[0][0] - $cities[1][0]) ** 2 + ($cities[0][1] - $cities[1][1]) ** 2 );
	my $dist_02 = sqrt( ($cities[0][0] - $cities[2][0]) ** 2 + ($cities[0][1] - $cities[2][1]) ** 2 );
	
	my $slow_dist_01 = 20 < $dist_01 ? 20 : $dist_01;
	my $arena_dist_01 = 20 < $dist_01 ? $dist_01 - 20 : 0;
	$debug and print "Slow-dist-01: $slow_dist_01, Arena-dist-01: $arena_dist_01\n";
	
	my $slow_dist_02 = 20 < $dist_02 ? 20 : $dist_02;
	my $arena_dist_02 = 20 < $dist_02 ? $dist_02 - 20 : 0;
	$debug and print "Slow-dist-02: $slow_dist_02, Arena-dist-02: $arena_dist_02\n";
	
	my @seconds = map { 
		my( $h, $m, $s ) = map s/^0//r, split /:/; 
		$h * 3600 + $m * 60 + $s * 1;
		} @times;
	
	my $diff = abs eval join ' - ', @seconds;
	
	my $sp = $unit * $xspeed;
	
	for my $arena_lvl ( 0 .. 20 ){
		my $time_01 = ($slow_dist_01 / $unit) + 
			($arena_dist_01 / ( $sp * ( 1 + 0.1 * $arena_lvl ) ) );
		my $time_02 = ($slow_dist_02 / $unit) + 
			($arena_dist_02 / ( $sp * ( 1 + 0.1 * $arena_lvl ) ) );
		my $time_diff = abs( $time_01 - $time_02 );
		
		printf "Arena lvl = %2d: %s\n", $arena_lvl, join '',
		map {
			my $h = int $_;
			$_ -= $h; $_ *= 60;
			my $m = int $_;
			$_ -= $m; $_ *= 60;
			my $s = $_;
			sprintf "%10s", join ':', map { sprintf "%02d", $_ } $h, $m, $s;
			}
			$time_01, $time_02, $time_diff, abs( $time_diff - $diff / 3600);
		}
	
	}