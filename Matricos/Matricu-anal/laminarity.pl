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
	
	$rr and do { printf "${printf}\n", $black / $rsl ; next };

	my %lenghts;
	my $sum = 0;
	map { my $len = length(); $sum += $len; $lenghts{ $len } ++ } 
		$data =~ /1{$minl,}/g;
	
	printf "${printf}\n", $sum / $black;

	if( $hist ){
		my $maxl = (sort {$b <=> $a} keys %lenghts)[ 0 ] || 0;
		printf "$_ : %s\n", map { $visual ? '*' x $_ : (sprintf "%3d", $_) } 
			exists $lenghts{ $_ } ? $lenghts{ $_ } : 0 
			for $minl .. $maxl;
	}
}
