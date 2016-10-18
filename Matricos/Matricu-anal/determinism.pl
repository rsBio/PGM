#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $minl = 2;
my $printf = '%f';
my $rr = 0;
my $hist = 0;
my $visual = 0;
my $longest = 0;
my $avg = 0; # average
my $ratio = 0;
my $entr = 0;

for (@opt){
	/-minl(\d+)/ and do {
		$minl = $1;
	};
	/-f(\S+)/ and do {
		$printf = "%$1";
	};
	/-rr/ and do {	# only show recurrence rate
		$rr = 1;
	};
	/-hist(v)?/ and do {
		$hist = 1;
		defined $1 and $visual = 1;
	};
	/-longest/ and do {
		$longest = 1;
	};
	/-avg/ and do {
		$avg = 1;
	};
	/-ratio/ and do {
		$ratio = 1;
	};
	/-entr/ and do {
		$entr = 1;
	};
	/-d/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	open my $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my $format = <$in>;
	$format =~ /P1/ or die "Not P1\n";
	my @rsl = split ' ', <$in>;
	my $rsl = $rsl[0] * $rsl[1];
	my $data = do { local $/ ; <$in> };
	my $black = () = $data =~ /1/g;

	# ***** skew and rotate-cw begin *****
	my $skewed = $data =~ s/\n+\z//r =~ s/\n/ '*' x ($rsl[1]) /ger;
	my $wide = $rsl[0] + $rsl[1] - 1;
	if( $debug ){
		print "Wide: $wide\n";
		print $skewed =~ s/.{$wide}\K/\n/gr;
	}
	
	my $i = 0;
	my @rotcw = ('') x $wide;
	while( length( my $chop = chop $skewed) ){
		$rotcw[ $wide - $i ++ % $wide - 1 ] .= $chop;
	}
	$debug and print "i: $i\n";
	$debug and print "$_\n" for @rotcw;
	# ***** skew and rotate-cw end *****

	$data = join "\n", @rotcw;
	
	$rr and do { printf "${printf}\n", $black / $rsl ; next };

	my %lengths;
	my $sum = 0;
	my @lines;
	map { my $len = length(); $sum += $len; $lengths{ $len } ++ } 
		@lines = $data =~ /1{$minl,}/g;
	
	my $determinism = $sum / $black;
	printf "${printf}\n", $determinism;
	
	if( $longest ){
		my $maxl = (sort {$b <=> $a} keys %lengths)[ 0 ] || 0;
		print "Longest: $maxl\n";
	}
	
	if( $avg ){
		printf "Average length: ${printf}\n", $sum / @lines;
	}

	if( $ratio ){
		printf "Ratio: ${printf}\n", $determinism * $rsl / $black;
	}
	if( $entr ){
		printf "Entrophy: ${printf}\n",  0 - eval join ' + ', 
			map { $lengths{ $_ } * log $lengths{ $_ } } keys %lengths;
	}
	
	if( $hist ){
		my $maxl = (sort {$b <=> $a} keys %lengths)[ 0 ] || 0;
		printf "%3d : %s\n", $_, map { $visual ? '*' x $_ : (sprintf "%3d", $_) } 
			exists $lengths{ $_ } ? $lengths{ $_ } : 0 
			for $minl .. $maxl;
	}
}
