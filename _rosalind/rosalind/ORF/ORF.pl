#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

my @data = <DATA>;
my %table = split ' ', join '', @data;

{ local $/ ; $_ = <> };

my( undef, $nucleotides ) = split /\n/, $_, 2;

$nucleotides =~ s/\s//g;
$nucleotides =~ s/T/U/g;

$debug and print $nucleotides;

my $reverse_complement = reverse $nucleotides =~ y/ACGU/UGCA/r;

$debug and print $reverse_complement;

my %found;

map { $found{ $_ } ++ } find_genes( $nucleotides );
map { $found{ $_ } ++ } find_genes( $reverse_complement );

print for sort keys %found;


sub find_genes{
	my( $nucleotides ) = shift;
	
	my $gene = '';
	my $protein = '';
	
	my %found;
	
	$nucleotides =~ /
		(?{ $gene = ''; })
		(?{ $protein = ''; })
		(?=AUG)
		(?: (.{3})
			(?{ $debug and print " \$1:$1" })
			(?(?{ 1 != length $table{ $1 } }) (*F) )
			(?{ $gene .= $1 })
			(?{ $protein .= $table{ $1 } })
			)*?
		U(?:AA|AG|GA)
		(?{ $debug and print $gene })
		(?{ $debug and print $protein })
		(?{ $found{ $protein } ++ })
		(*F)
		/x;
	
	return keys %found;
	}

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