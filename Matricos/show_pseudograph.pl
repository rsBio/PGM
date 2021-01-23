#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @FILES;
my @opt;

for( @ARGV ){
	/^-\S/ ? ( push @opt, $_ ) : ( push @FILES, $_ );
}

my $height = 50;
my $x_axis_simple = 1;
my $x_axis_steps = 0;
my $step;

my $split = " ";
my $join = " ";

for( @opt ){
	/-height(\d+)/ and do {
		$height = $1;
	};
	/-step(\S+)/ and do {
		$step = $1;
		$x_axis_simple = 0;
		$x_axis_steps = 1;
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
	/-d$/ and $debug = 1;
}

for( @FILES ){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split $split, $_, -1 ] } 
		grep m/./, ( defined $in ? <$in> : <STDIN> );
	
	if( $x_axis_simple ){
		my @matrix;
		
		my( $vertical_min, $vertical_max ) = global_min_max( \@data );
		my $vertical_size = $vertical_max - $vertical_min;
		
		x_axis_simple( \@data, \@matrix, $height, $vertical_size, $vertical_min );
		
		print "P2\n";
		print @{ $data[ 0 ] } . " " . $height . "\n";
		print "255\n";
		print do { local $" = $join; "@{$_}\n" } for @matrix;
		}
	elsif( $x_axis_steps ){
		my @ppm_matrix;
		
		my @x_axes = @data[ grep $_ < @data, map 2 * $_, 0 .. @data - 1 ];
		$debug and print "[@{$_}]\n" for @x_axes;
		
		my @data = @data[ grep $_ < @data, map 2 * $_ + 1, 0 .. @data - 1 ];
		$debug and print "[@{$_}]\n" for @data;
		
		my( $vertical_min, $vertical_max ) = global_min_max( \@data );
		my $vertical_size = $vertical_max - $vertical_min;
		
		my( $horizontal_min, $horizontal_max ) = global_min_max( \@x_axes );
		my $horizontal_size = $horizontal_max - $horizontal_min;
		
		my $width = $horizontal_size / $step + 1;
		
		my $max_value = 255;
		
		x_axis_steps( \@data, \@x_axes, \@ppm_matrix, $height, $vertical_size, $vertical_min,
			$step, $width, $horizontal_min, $horizontal_max, $horizontal_size, $max_value );
		
		print "P3\n";
		print $width . " " . $height . "\n";
		print $max_value . "\n";
		for( @ppm_matrix ){
			for( @{ $_ } ){
				print " @{ $_ } ";
				}
			print "\n";
			}
		}
}	

sub global_min_max {
	my( $ref_data ) = @_;
	
	my( $Mmin, $Mmax ) = ( ~0, -~0 );
	
	for my $graph ( @{ $ref_data } ){
		my( $min, $max ) = ( ~0, -~0 );
		for my $value ( @{ $graph } ){
			$value > $max and $max = $value;
			$value < $min and $min = $value;
			}
		my $wide = $max - $min;
		$min < $Mmin and $Mmin = $min;
		$max > $Mmax and $Mmax = $max;
		$debug and print "vertical::min,max,wide:$min|$max|$wide\n";
		}
	
	return $Mmin, $Mmax;
	}

sub x_axis_simple {
	my( $ref_data, $ref_matrix, $height, $vertical_size, $vertical_min ) = @_;
	
	push @{ $ref_matrix }, [ ( 0 ) x @{ $ref_data->[ 0 ] } ] for 1 .. $height;
	my $occ_max = 0;
	
	for my $graph ( @{ $ref_data } ){
		for my $i ( 1 .. @{ $graph } ){
			my $ind = $height - 
				( $graph->[ $i - 1 ] - $vertical_min ) * $height / $vertical_size;
			$ind > $height and die "ind($ind) > height($height)\n";
			$ind == $height and $ind --;
			$ref_matrix->[ $ind ][ $i - 1 ] ++;
			$ref_matrix->[ $ind ][ $i - 1 ] > $occ_max and 
				$occ_max = $ref_matrix->[ $ind ][ $i - 1 ];
			}
		}
	$debug and print "$occ_max\n";
	
	for my $row ( @{ $ref_matrix } ){
		for my $i ( 1 .. @{ $row } ){
			$row->[ $i - 1 ] or do { $row->[ $i - 1 ] = 255; next };
			$row->[ $i - 1 ] = int 255 - 255 / $occ_max * $row->[ $i - 1 ];
			}
		}
	}

sub x_axis_steps {
	my( $ref_data, $ref_x_axes, $ref_ppm_matrix, $height, $vertical_size, $vertical_min,
			$step, $width, $horizontal_min, $horizontal_max, $horizontal_size, $max_value ) = @_;
	
	for my $i ( 0 .. $height - 1 ){
		for my $j ( 0 .. $width - 1 ){
			$ref_ppm_matrix->[ $i ][ $j ] = [ $max_value, $max_value, $max_value ];
			}
		}
	
	for my $row ( 0 .. @{ $ref_x_axes } - 1 ){
		for my $j ( 0 .. @{ $ref_x_axes->[ $row ] } - 1 ){
			my $j_step = ( $ref_x_axes->[ $row ][ $j ] - $horizontal_min ) / $step;
			if( abs( $j_step - int $j_step + 1e-9 ) > 1e-9){
				die "Some data points do not match step indexes: " .
					$j_step . " != " . ( int $j_step ) . "\n" .
					"at \$row:[$row], \$j:[$j]\n";
				}
			
			my $y = $height - 
				( $ref_data->[ $row ][ $j ] - $vertical_min ) * $height / $vertical_size;
			$y > $height and die "ind($y) > height($height)\n";
			$y == $height and $y --;
			
			my $darkness = 100;
			
			$ref_ppm_matrix->[ $y ][ $j_step ][ 0 ] -= 
				0 + ( ( $row + 0 ) % @{ $ref_x_axes } == 0 ? 0 : $darkness );
			$ref_ppm_matrix->[ $y ][ $j_step ][ 1 ] -= 
				0 + ( ( $row + 1 ) % @{ $ref_x_axes } == 0 ? 0 : $darkness );
			$ref_ppm_matrix->[ $y ][ $j_step ][ 2 ] -= 
				0 + ( ( $row + 2 ) % @{ $ref_x_axes } == 0 ? 0 : $darkness );
			}
		}
	}
;
;
;
;
;
;
;
;
;
;
;
;