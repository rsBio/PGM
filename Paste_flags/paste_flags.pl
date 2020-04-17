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
my $coords_file;
my $prism_file;
my $symbols_pbm;
my $solutions = 0;

for( @opt ){
	/-coords-file=(\S+)/ and do {
		$coords_file = $1;
	};
	/-prism-file=(\S+)/ and do {
		$prism_file = $1;
	};
	/-symbols-pbm=(\S+)/ and do {
		$symbols_pbm = $1;
	};
	/-sol(?:utions)?/ and do {
		$solutions = 1;
	};
	/-ssv/ and do {
		$split = ' ';
	};
	/-nosep/ and do {
		$split = '';
	};
	/-d$/ and $debug = 1;
}

if( @FILES != 1 ){
	die "$0: Only one file can be processed at once. $!\n";
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
	
	
	open my $in_coords_file, '<', $coords_file or die "$0: [$coords_file] Can't open file : $!\n";
	
	while( <$in_coords_file> ){
		my( $col, $row, $distance, $letter, $nr, $place ) = split;
		
		paste_flag( $col, $row, $distance, $letter, $nr, $place );
		}
	
	
	print "$header\n";
	print "$cols $rows\n";
	print "$maxval\n" if defined $maxval;
	
	for my $ref_row ( @enveloped ){
		my @line;
		
		for my $ref_tuple ( @{ $ref_row } ){
			push @line, @{ $ref_tuple };
			}
		
		print map "$_\n", join $join, @line;
		}
}

sub paste_flag{
	my( $col, $row, $distance, $letter, $nr, $place ) = @_;
	
	my $px_width = int( 56 * 13 / $distance );

	my $leg_height = 2;
	my $leg_width = $px_width / 10;
	$leg_width < 3 and $leg_width = 3;
	
	my $start_row = $row - $px_width * ( 1 + $leg_height );
	my $start_col = $col - ( $px_width >> 1 );
	my $start_col_leg = $col - ( $leg_width >> 1 );
	
	# BEGIN prism:
	
	my $border = 0;
	
	for my $i ( $start_row .. $start_row + $border - 1,
		$start_row + $px_width - $border .. $start_row + $px_width - 1,
		){
		for my $j ( $start_col .. $start_col + $px_width - 1 ){
			$enveloped[ $i ][ $j ] = [ 0, 0, 0 ];
			}
		}
	
	for my $i ( $start_row + $border .. $start_row + $px_width - $border - 1 ){
		for my $j ( $start_col .. $start_col + $border - 1,
			$start_col + $px_width - $border .. $start_col + $px_width - 1,
			){
			$enveloped[ $i ][ $j ] = [ 0, 0, 0 ];
			}
		for my $j ( $start_col + $border .. $start_col + $px_width - $border - 1 ){
			if( $solutions ){
				if( $nr == 0 ){ $enveloped[ $i ][ $j ] = [ 200, 100, 100 ]; } # darker red
				elsif( $letter eq 'Z' ){ $enveloped[ $i ][ $j ] = [ 100, 150, 255 ]; } # blue
				else{ $enveloped[ $i ][ $j ] = [ 255, 100, 100 ]; } # red
				}
			else {
				$enveloped[ $i ][ $j ] = [ 255, 100, 100 ]; # red
				}
			if( $i + $j < $start_row + $start_col + $px_width ){
				if( $solutions and $nr < 0 ){
					$enveloped[ $i ][ $j ] = [ 200, 200, 200 ];
					}
				else{
					$enveloped[ $i ][ $j ] = [ 220, 220, 220 ];
					}
				}
			}
		}
	
	# END prism;
	
	# BEGIN leg:
	
	for my $i ( $start_row + $px_width .. $start_row + $px_width * ( 1 + $leg_height ) - 1 ){
		for my $j ( $start_col_leg .. $start_col_leg + $leg_width - 1 ){
			if( $solutions or $letter ne 'Z' ){
			$enveloped[ $i ][ $j ] = [ 255, 255, 255 ];
			}
		}
	
	# END leg;
	
	# BEGIN info:
	
	if( $place eq 'u' ){
		$start_row = $start_row -= 100;
		}
	else{
		$start_row = $row + 30;
		}
	
	if( $nr == 0 ){
		$start_col = $col - 18;
		}
	else{
		$start_col = $col - 0;
		}
	
	open my $in_symbols_pbm, '<', $symbols_pbm or die "$0: [$symbols_pbm] Can't open file : $!\n";
	
	my @data = <$in_symbols_pbm>;
	shift @data;
	my( $cols, $rows ) = split ' ', shift @data;
	
	my $char_height = $rows / 96;
	my $char_width = $cols;
	
	my %char_hash;
	
	for my $char ( map chr, 0x20 .. 0x7F - 1 ){
		for my $i ( 0 .. $char_height - 1 ){
			@{ $char_hash{ $char }[ $i ] } = split ' ', shift @data;
			}
		}
	
	for my $i ( $start_row .. $start_row + $char_height - 1 ){
		for my $j ( $start_col .. $start_col + $char_width - 1 ){
			$enveloped[ $i ][ $j ] = [ ( 255 * ( 1 - $char_hash{ $letter }[ $i - $start_row ][ $j - $start_col ] ) ) x 3 ];
			}
		}
	
	for my $i ( $start_row .. $start_row + $char_height - 1 ){
		last if $nr == 0;
		$start_col = $col - 36;
		for my $j ( $start_col .. $start_col + $char_width - 1 ){
			$enveloped[ $i ][ $j ] = [ ( 255 * ( 1 - $char_hash{ $nr }[ $i - $start_row ][ $j - $start_col ] ) ) x 3 ];
			}
		}
	
	# END info;
	
	}