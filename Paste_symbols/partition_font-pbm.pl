#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;
my $debug_generate_partitioned_font_pbm = 1;

my @FILES;
my @opt;

for( @ARGV ){
	/^-\S/ ? ( push @opt, $_ ) : ( push @FILES, $_ );
}

my $split = " ";
my $join = " ";
my $partition_font_pbm = 0;

for( @opt ){
	/-partition-font-pbm/ and do {
		$partition_font_pbm = 1;
	};
	/-ssv/ and do {
		$split = ' ';
	};
	/-nosep/ and do {
		$split = '';
	};
	/-d$/ and $debug = 1;
}

my @symbols = map chr, 0x20 .. 0x7F;
pop @symbols;
push @symbols, $symbols[ 0 ];

$debug and print STDERR "[", @symbols, "]\n";


for( @FILES ){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = grep m/./, ( defined $in ? <$in> : <STDIN> );
	chomp @data;
	
	my( $header ) = shift @data;
	my( $cols, $rows ) = split ' ', shift @data;
	
	@data = map { [ split ] } @data;
	
	## FONT PBM is 12 x 8 format ##
	
	my $char_height = int $rows / 8;
	my $left = ( $char_height + 1 ) * 8 - $rows;
	
	$debug and print STDERR "left for height:[$left]\n";
	
	for my $i ( 1 .. $left ){
		splice @data, $char_height * $i, 0, [ @{ $data[ $char_height * $i - 1 ] } ];
		}
	
	$rows += $left;
	$char_height ++;
	
	my $char_width = int $cols / 12;
	$left = ( $char_width + 1 ) * 12 - $cols;
	
	$debug and print STDERR "left for width:[$left]\n";
	
	for my $i ( 1 .. $left ){
		for my $j ( 0 .. $rows - 1 ){
			splice @{ $data[ $j ] }, $char_width * $i, 0, $data[ $j ][ $char_width * $i - 1 ];
			}
		}
	
	$cols += $left;
	$char_width ++;
	
	for my $i ( grep { $_ % $char_height == 0 } 0 .. $rows - 1 ){
		for my $j ( 0 .. $cols - 1 ){
			$partition_font_pbm and $data[ $i ][ $j ] = 1;
			}
		}
	
	for my $i ( grep { $_ % $char_width == 0 } 0 .. $cols - 1 ){
		for my $j ( 0 .. $rows - 1 ){
			$partition_font_pbm and $data[ $j ][ $i ] = 1;
			}
		}
	
	if( $debug_generate_partitioned_font_pbm ){
		open my $out, '>', 'partitioned_' . $_ or die "$0: Can't open ", 'partitioned_' . $_, " : $!\n";
		print $out "$header\n";
		print $out "$cols $rows\n";
		print $out map "$_\n", join ' ', @{ $_ } for @data;
		}
	
	my %char_hash;
	my $k = 0;
	
	OUTER:
	for my $big_row ( 0 .. 8 - 1 ){
		for my $big_col ( 0 .. 12 - 1 ){
			my $char = $symbols[ $k ];
			$k ++;
			#$k > 2 and last OUTER;
			for my $i ( 0 .. $char_height - 1 ){
				@{ $char_hash{ $char }[ $i ] } = 
					@{ $data[ $big_row * $char_height + $i ] }
						[ $big_col * $char_width + 0 .. $big_col * $char_width + $char_width - 1 ];
			#	print STDERR "<@{ $char_hash{ $char }[ $i ]}>\n";
				}
			}
		}
	
	$debug and print STDERR "char_width:[$char_width], char_height:[$char_height]\n";
	
	$debug and print STDERR "[@{ $_ }]\n" for @{ $char_hash{ 'A' } };
	$debug and print STDERR "-" x 25 . "\n";
	
	print "P1\n";
	print $char_width . ' ' . $char_height * @symbols . "\n";
	for my $i ( 0 .. @symbols - 1 ){
		print "@{ $_ }\n" for @{ $char_hash{ $symbols[ $i ] } };
		}
	}

__END__
 !"#$%&'()*+
,-./01234567
89:;<=>?@ABC
DEFGHIJKLMNO
PQRSTUVWXYZ[
\]^_`abcdefg
hijklmnopqrs
tuvwxyz{|}~ 

[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ]
