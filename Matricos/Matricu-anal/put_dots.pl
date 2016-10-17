#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $bnum = 0;
my $bproc;
my $wnum = 0;
my $wproc;

for (@opt){
	/-b(\d+)(%)?/ and do {
		($2 ? $bproc : $bnum) = $1;
	};
	/-w(\d+)(%)?/ and do {
		($2 ? $wproc : $wnum) = $1;
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
	my $b = () = $data =~ /1/g;
	my $w = () = $data =~ /0/g;

	defined $bproc and $bnum = int $rsl * $bproc / 100;
	defined $wproc and $wnum = int $rsl * $wproc / 100;
	
	$bnum > $w and die "$0: bnum[$bnum] > w[$w]: $!\n";
	$wnum > $b and die "$0: wnum[$wnum] > b[$b]: $!\n";

	my %hb = map { $_, undef } 1 .. $w;
	my %bchange;

	for my $i (1 .. $bnum){
		my $key = (keys %hb)[ 0 ];
		$bchange{ $key } = 1;
		delete $hb{ $key };
	}
	$debug and print map "b[$_]\n", join ' ', keys %bchange;

	my %hw = map { $_, undef } 1 .. $b;
	my %wchange;

	for my $i (1 .. $wnum){
		my $key = (keys %hw)[ 0 ];
		$wchange{ $key } = 1;
		delete $hw{ $key };
	}
	$debug and print map "w[$_]\n", join ' ', keys %wchange;

	my $i = 0;
	$data =~ s/0/
		do {
			$i ++;
			$bchange{ $i } ? 1 : 0
		}
	/eg;

	$i = 0;
	$data =~ s/1/
		do {
			$i ++;
			$wchange{ $i } ? 0 : 1
		}
	/eg;

	print $format;
	print "@rsl\n";
	print $data;
}
