#!/usr/bin/perl

use warnings;
use strict;

sub findxy {
	my( $Ax, $Ay, $Bx, $By, $ab, $ac, $bc ) = @_;
	my( $x, $y ) = (0, 0);
	for my $i (1 .. 5){
	my $step = 1;
	while( $step > 0.001 ){
		my ($ref_closer) = 
		# Schwartzian transform:
		map { [ $_->[0], $_->[1] ] }
		(
		sort { $a->[2] <=> $b->[2] }
		map {
			my( $x1, $y1 ) = @{ $_ };
			[ $x1, $y1,
			abs( $ac - sqrt( ($Ax - $x1)**2 + ($Ay - $y1)**2 ) ) +
			abs( $bc - sqrt( ($Bx - $x1)**2 + ($By - $y1)**2 ) )
			]
		}
			[ $x, $y ],
			[ $x + $step, $y + $step ],
			[ $x + $step, $y - $step ],
			[ $x - $step, $y + $step ],
			[ $x - $step, $y - $step ],
		)[ 0 ];
			
		($x, $y) = @{$ref_closer};
	#	print "[$x|$y]\n";
		$step *= 0.7;
	}
	}
	"[$x|$y]\n"
}

#print findxy( $Ax, $Ay, $Bx, $By, $ab, $ac, $bc );
#findxy( 0, 0, 2, 0, 2, 5, 4 ) for 1 .. 1000;
print findxy( 0, 0, 2, 0, 2, 5, 4 );
