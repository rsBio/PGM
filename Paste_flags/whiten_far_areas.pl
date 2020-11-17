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
my $distance_px = 100;
my $zealous_crop_up_down = 0;

for( @opt ){
	/-dist(?:ance-px)?(\d+)/ and do {
		$distance_px = $1;
	};
	/-zcrop-UD/ and do {
		$zealous_crop_up_down = 1;
	};
	/-ssv/ and do {
		$split = ' ';
	};
	/-nosep/ and do {
		$split = '';
	};
	/-d$/ and $debug = 1;
}

my @enveloped;

for( @FILES ){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = grep m/./, ( defined $in ? <$in> : <STDIN> );
	chomp @data;
	
	my $header = shift @data;
	my( $cols, $rows ) = split ' ', shift @data;
	
	my $maxval;
	
	if( $header =~ /^P[23]$/ ){
		$maxval = shift @data;
		}
	
	my $cols_P = $cols;
	
	if( $header eq 'P3' ){
		$cols_P *= 3;
		}
	
	my $i = 0;
	
	while( @data ){
		my @values = split $split, shift @data;
		
		while( @values ){
			my @tuple = shift @values;
			if( $header eq 'P3' ){
				push @tuple, shift @values, shift @values;
				}
			push @{ $enveloped[ $i ] }, [ @tuple ];
			}
		
		$i ++;
		}
	
	
	my @purple;
	
	for my $i ( 0 .. $rows - 1 ){
		for my $j ( 0 .. $cols - 1 ){
			if( $enveloped[ $i ][ $j ][ 0 ] + $enveloped[ $i ][ $j ][ 2 ] >
				$enveloped[ $i ][ $j ][ 1 ] + 300 ){
				push @purple, [ $i, $j ];
				}
			}
		}
		
	print STDERR "purple: ", ~~ @purple, "\n";
	
	my @selected_purple;
	
	push @selected_purple, $purple[ rand( @purple ) ] for 1 .. 5;
	
	print STDERR "selected_purple:[@{ $_ }]\n" for @selected_purple;
	
	for my $i ( 0 .. $rows - 1 ){
		for my $j ( 0 .. $cols - 1 ){
			for my $k ( 0 .. @selected_purple - 1 ){
				if( ( $i - $selected_purple[ $k ][ 0 ] ) ** 2 + 
					( $j - $selected_purple[ $k ][ 1 ] ) ** 2 > $distance_px ** 2 ){
					$enveloped[ $i ][ $j ] = [ 220, 220, 220 ];
					}
				}
			}
		}
	
	my $ok_start;
	my $ok_end;
	
	my @keys;
	
	if( $zealous_crop_up_down ){
		for my $i ( 0 .. $rows - 1 ){
			my %similarity;
			
			for my $j ( 0 .. $cols - 1 ){
				$similarity{ "@{ $enveloped[ $i ][ $j ] }" } ++;
				}
			
			if( 1 < keys %similarity ){
				defined $ok_start or $ok_start = $i;
				$ok_end = $i;
				}
			}
		}
	
	print STDERR "$ok_start,$ok_end\n";
	
	splice @enveloped, $ok_end, -1, ();
	splice @enveloped, 0, $ok_start + 1, ();
	
	print "$header\n";
	print "$cols " . ~~ @enveloped . "\n";
	print "$maxval\n" if defined $maxval;
	
	for my $ref_row ( @enveloped ){
		my @line;
		
		for my $ref_tuple ( @{ $ref_row } ){
			push @line, @{ $ref_tuple };
			}
		
		print map "$_\n", join $join, @line;
		}
}
