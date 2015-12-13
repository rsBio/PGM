#!/usr/bin/perl

use warnings;
use strict;

while(@ARGV){
	my $file = shift @ARGV;
	open my $fh, '<', $file or die "$0: Can't open $!!\n";

	$_ = do { local $/ ; <$fh> };
	my ($first_line, @lines) = split /\n/;
	my ($len, $n, $m) = split ' ', $first_line;

	my @matrix = map [split], @lines;
	
	my @rows;
	my @cols;
	my %rects;

	for my $i (1 .. $len){
		$rows[ $i ][ $_ ] ++ for @{ $matrix[ $i-1 ] };
#%		print "{@{ $rows[ $i ] }}\n";
	}

	for my $j (1 .. $len){
		for my $i (1 .. $len){
			$cols[ $j ][ $matrix[ $i-1 ][ $j-1 ] ] ++;
		}
#%		print "{@{ $cols[ $j ] }}\n";
	}

	for (my $i = 1; $i <= $len; $i += $n){
		for (my $j = 1; $j <= $len; $j += $m){
#%			print "\n";
			$rects{ $i }{ $j } = [ ];
			for my $ii ($i .. $i + $n - 1){
				for my $jj ($j .. $j + $m - 1){
					$rects{ $i }{ $j }[ $matrix[$ii-1][$jj-1] ] ++;
#%					print "$matrix[$ii-1][$jj-1] | $ii $jj\n";
				}
			}
#%			print "[@{ $rects{ $i }{ $j } }]\n";
		}
	}

	my @seq;

	for my $j (1 .. $len){
		for my $i (1 .. $len){
			$matrix[ $i-1 ][ $j-1 ] == 0 
				and push @seq, [ $i, $j, 0 ];
		}
	}
#%	print "@$_\n" for @seq;
	
	my $ptr = 0;
	my $back = 0;
	my $fail = 0;

	SEQ:
	while( $ptr < @seq ){
		
		if( $ptr < 0 ){
			$fail = 1; last
		}
		
		if( $back ){
			$back = 0;

			undef $rows[ $seq[$ptr][0] ][ $seq[$ptr][2] ];
			undef $cols[ $seq[$ptr][1] ][ $seq[$ptr][2] ];
			undef $rects{ int( ($seq[$ptr][0]-1) / $n) * $n +1 }{
					int( ($seq[$ptr][1]-1) / $m) * $m +1 
					}[ $seq[$ptr][2] ];
		}

		while( 'TRUE' ){
			$seq[ $ptr ][2] ++;
			$seq[ $ptr ][2] > $len and do {
				$seq[ $ptr ][2] = 0;

				$back = 1 ; $ptr -- ; next SEQ 
			};
			next if 0
				|| defined $rows[ $seq[$ptr][0] ][ $seq[$ptr][2] ]
				|| defined $cols[ $seq[$ptr][1] ][ $seq[$ptr][2] ]
				|| defined $rects{ 
					int( ($seq[$ptr][0]-1) / $n) * $n +1 }{ 
					int( ($seq[$ptr][1]-1) / $m) * $m +1 
					}[ $seq[$ptr][2] ]
			;
			$rows[ $seq[$ptr][0] ][ $seq[$ptr][2] ] ++;
			$cols[ $seq[$ptr][1] ][ $seq[$ptr][2] ] ++;
			$rects{ int( ($seq[$ptr][0]-1) / $n) * $n +1 }{
				int( ($seq[$ptr][1]-1) / $m) * $m +1 
			}[ $seq[$ptr][2] ] ++;
			
			$ptr ++;
			next SEQ;
		}
	}

	if( $fail ){
		print "FAIL!\n";
	} else {

		open my $out, '>', "$file-out" or die "$0: Can't create $!!\n";

		for my $seq (@seq){
			my ($x, $y, $v) = @$seq;
			$matrix[ $x-1 ][ $y-1 ] == 0 ?
				($matrix[ $x-1 ][ $y-1 ] = $v)
			:
				print "ERR!\n";
		}
		print $out "$first_line\n";
		for my $i (1 .. $len){
			print $out "@{ $matrix[$i-1] }\n";
		}
	}

}
