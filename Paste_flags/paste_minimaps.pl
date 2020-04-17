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
my $minimap;

for( @opt ){
	/-minimap=(\S+)/ and do {
		$minimap = $1;
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
my @mini_enveloped;

for( @FILES ){
	open my $in, '<', $_ or die "$0: [$_] ... : $!\n";
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
	
	
	open my $mini_in, '<', $minimap or die "$0: [$minimap] ... : $!\n";
	my @mini_data = grep m/./, <$mini_in>;
	chomp @mini_data;
	
	my $mini_header = shift @mini_data;
	my( $mini_cols, $mini_rows ) = split ' ', shift @mini_data;
	
	my $mini_maxval;
	
	if( $mini_header =~ /^P[23]$/ ){
		$mini_maxval = shift @mini_data;
		}
	
	my $mini_cols_P = $mini_cols;
	
	if( $mini_header eq 'P3' ){
		$mini_cols_P *= 3;
		}
	
	$i = 0;
	
	while( @mini_data ){
		my @values = split $split, shift @mini_data;
		
		while( @values ){
			my @tuple = shift @values;
			if( $header eq 'P3' ){
				push @tuple, shift @values, shift @values;
				}
			push @{ $mini_enveloped[ $i ] }, [ @tuple ];
			}
		
		$i ++;
		}
	
	
	my $start_row = $rows - $mini_rows;
	my $start_col = $cols - $mini_cols >> 1;
	
	for my $i ( 0 .. $mini_rows - 1 ){
		for my $j ( 0 .. $mini_cols - 1 ){
			$enveloped[ $i + $start_row ][ $j + $start_col ] = [ @{ $mini_enveloped[ $i ][ $j ] } ] ;
			}
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
