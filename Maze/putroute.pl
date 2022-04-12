#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @FILES;
my @opt;

for( @ARGV ){
	/^-\S/ ? ( push @opt, $_ ) : ( push @FILES, $_ );
}

my $split = " ";
my $join = " ";
my $connect = 0;

for( @opt ){
	/-connect/ and do {
		$connect = 1;
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

$_ = shift @FILES;
open my $maze_fh, '<', $_ or die "$0: [$_] ... : $!\n";
my @maze = grep m/./, <$maze_fh>;

shift @maze; # discard magic number
my( $cols, $rows ) = split ' ', shift @maze;

@maze = map { [ split ] } @maze;

$debug and print "----------\n";
$debug and print "@{$_}\n" for @maze;
$debug and print "---\n";

$_ = shift @FILES;
open my $heads_fh, '<', $_ or die "$0: [$_] ... : $!\n";
my @heads = grep m/./, <$heads_fh>;

print STDERR $_ for @heads;

my @routes;

for( @FILES ){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @route = grep m/./, ( defined $in ? <$in> : <STDIN> );
	chomp @route;
	
	print STDERR shift @route; # print user name;
	
	push @routes, [ map { [ m/\d+/g ] } @route ];
	}

my $shortest_route = ( sort { $a <=> $b } map { 0 + @{ $_ } } @routes )[ 0 ];

print STDERR $shortest_route . "\n";

for my $step ( 0 .. $shortest_route - 1 ){
	my @maze_frame;
	push @maze_frame, [ @{ $_ } ] for @maze;
	
	my $route_nr = 0;
	for my $route ( @routes ){
		$route_nr ++;
		
		print STDERR $route_nr;
		
		my( $prev_x, $prev_y );
		
		for my $step2 ( grep $_ >= 0, $step - 8 .. $step ){
		
			my( $x, $y ) = @{ $route->[ $step2 ] };
			
			if( $connect ){
				my( $xx, $yy ) = ( $prev_x, $prev_y );
				while( defined $xx and not( $xx == $x and $yy == $y ) ){
					my $min_diff = 1e9;
					my( $add_i, $add_j );
					for my $i ( -1, 0, 1 ){
						for my $j ( -1, 0, 1 ){
							my $diff = ( $x - ( $xx + $i ) ) ** 2 + 
								( $y - ( $yy + $j ) ) ** 2;
							if( $diff <= $min_diff ){
								$min_diff = $diff;
								$add_i = $i;
								$add_j = $j;
								}
							}
						}
					$xx += $add_i;
					$yy += $add_j;
					$maze_frame[ $yy ][ $xx ] = 1;
					}
				
				( $prev_x, $prev_y ) = ( $x, $y );
				}
			
			for my $xx ( 0 .. 9 ){
				for my $yy ( 0 .. 9 ){
					
					if( $y - 5 + $xx >= 0 and $y - 5 + $xx < $cols 
						and $x - 5 + $yy >= 0 and $x - 5 + $yy < $rows
						and int( ( $step - $step2 ) / 3 ) < 
							substr $heads[ ( $route_nr - 1 ) * 10 + $xx ], $yy, 1
						){
						$maze_frame[ $y - 5 + $xx ][ 
							$x - 5 + $yy ] = 1;
						}
					}
				}
			}
		}
	
	open my $frame_fh, '>', ( sprintf "frame_%03d.pbm", $step ) 
		or die "$0: [$_] ... : $!\n";
	
	print $frame_fh "P1\n";
	print $frame_fh "$cols $rows\n";
	print $frame_fh "@{$_}\n" for @maze_frame;
	}
