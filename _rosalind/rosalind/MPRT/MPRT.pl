#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

my $debug = 0;

chomp(
	my @uniprot_ids = <>
	);

my $N_glycosylation_motif = "N[^P][ST][^P]";
my $len = 5;

use LWP::Simple;

for my $id ( @uniprot_ids ){
	my $url = "http://www.uniprot.org/uniprot/${id}.fasta";
	
	$debug and print $url;
	
	my $fasta = get( $url );
	
	$debug and print $fasta;
	
	$fasta =~ s/.*//;
	$fasta =~ s/\s//g;
	
	$debug and print $fasta;
	
	my @pos;
	
	while( $fasta =~ /(?= $N_glycosylation_motif )/gx ){
		push @pos, 1 + pos $fasta;
		}
	
	if( @pos ){
		print $id;
		print "@pos";
		}
	}


