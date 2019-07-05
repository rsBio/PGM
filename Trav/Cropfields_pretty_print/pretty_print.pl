#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

for (@opt){
	/-d/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	local $/;
	my $data = (defined $in ? <$in> : <STDIN>);
	
	print $data;
	$data =~ s/ą/a/g;
	$data =~ s/č/c/g;
	$data =~ s/ę/e/g;
	$data =~ s/ė/e/g;
	$data =~ s/į/i/g;
	$data =~ s/š/s/g;
	$data =~ s/ų/u/g;
	$data =~ s/ū/u/g;
	$data =~ s/ž/z/g;
	$data =~ s/−/-/g;
	print $data;
	my @normal = $data =~ /[\s\w[:punct:]]/ig;
	print join '', @normal;
	$data = join '', @normal; 
	
	my $matchcnt = () = $data =~ /^(?:\d+(?:\.\d)?)/mgsx;
	print "MATCHCNT:$matchcnt\n";
	
	my @matches = $data =~ /^
		(?:\d+(?:\.\d)?)
		\s+ [(]-?\d+\|-?\d+[)]
		\s+ \d+-grudzi?ai
		\s+ \+\d+%
		\s+ [\w[:punct:]]+
		\s+ [\w[:punct:]]+
	/gmxs;
	print join "\n", @matches;
	
	my $spaces = 14;
	
	print "\n";
	print "Daugiagrūdžiai\n";
#	printf "%${spaces}s", $_ for ( "Atstumas", "Koordinatės", "Tipas", "Oazė", "Užimtas nuo", "Aljansas" );
	my @header_chunks = map { sprintf "%${spaces}s", $_ } ( "Atstumas", "Koordinates", "Tipas", "Oaze", "Uzimtas nuo", "Aljansas" );
	map s/^\s+/ ' ' . '_' x ( -1 + length $& ) /e, @header_chunks;
	print join '', @header_chunks;
	print "\n";
	
	for my $match ( @matches ) {
		my @chunks = split /[\n\t]+/, $match;
		s/\s+$// for @chunks;
		map { $_ = sprintf "%${spaces}s", $_ } @chunks;
	#	print join '', @chunks;
	#	print "\n";
		
		$chunks[ 1 ] =~ s/\s+\K.+/[x|y]${&}[\/x|y]/;
		$chunks[ 4 ] =~ s/\s+\K.+/[žaidėjas]${&}[\/žaidėjas]/ if not $chunks[ 4 ] =~ /^\s+----$/;
		$chunks[ 5 ] =~ s/\s+\K.+/[aljansas]${&}[\/aljansas]/ if not $chunks[ 5 ] =~ /^\s+nera$/;
		
		map s/^\s+/ ' ' . '_' x ( -1 + length $& ) /e, @chunks;
		print join '', @chunks;
		print "\n";
	}
}
