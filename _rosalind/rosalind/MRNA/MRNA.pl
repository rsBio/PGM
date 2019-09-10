#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my @data = <DATA>;
my @reversed = reverse split ' ', join '', @data;

my %h;

while( @reversed ){
	my( $aa, $codon ) = shift @reversed, shift @reversed;
	$h{ $aa } ++;
	}

{ local $/ ; $_ = <> };

my $cnt = 1;
my $MOD = 1e6;

/
	.
	(?{ 
		$cnt *= $h{ $& };
		$cnt %= $MOD;
		})
	(*F)
	/x;

print $cnt * $h{ 'Stop' } % $MOD;

__DATA__
UUU F      CUU L      AUU I      GUU V
UUC F      CUC L      AUC I      GUC V
UUA L      CUA L      AUA I      GUA V
UUG L      CUG L      AUG M      GUG V
UCU S      CCU P      ACU T      GCU A
UCC S      CCC P      ACC T      GCC A
UCA S      CCA P      ACA T      GCA A
UCG S      CCG P      ACG T      GCG A
UAU Y      CAU H      AAU N      GAU D
UAC Y      CAC H      AAC N      GAC D
UAA Stop   CAA Q      AAA K      GAA E
UAG Stop   CAG Q      AAG K      GAG E
UGU C      CGU R      AGU S      GGU G
UGC C      CGC R      AGC S      GGC G
UGA Stop   CGA R      AGA R      GGA G
UGG W      CGG R      AGG R      GGG G