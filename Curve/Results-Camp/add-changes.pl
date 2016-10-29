#!/usr/bin/perl

use warnings;
use strict;

my %hashes;
my $tourn;

for (@ARGV){
	open my $in, '<', "$_" or die "$0: Can't open '$_': $!\n";
	s/\.\w+$//;
	$tourn = $_;
	
	for (<$in>){
		s/\s+//;
		m/([^-]*)-.*?(\d+:\d+\.\d+)/ or next;
		my $name = $1;
		my $time = $2;
		$name =~ s/\s+$//;
		$hashes{ $tourn }{ $name } = [ $time ];
	}
}

my $this = $ARGV[0] =~ s/\.\w+$//r;

for my $name (keys %{ $hashes{ $this } }){
	for my $tourn (grep $this ne $_, sort {$b <=> $a} keys %hashes){
		exists $hashes{ $tourn }{ $name } or next;
		my ($time) = @{ $hashes{ $tourn }{ $name } };
		push @{ $hashes{ $this }{ $name } }, "$tourn->$time";
	}
}

my @names =
	map { $_->[0] }
	sort { $b->[1] <=> $a->[1] } 
	map { 
		my $time = $hashes{ $this }{ $_ }[0];
		$time =~ s/^(?=\d:)/0/;
		$time =~ y/.//d;
		$time =~ s/:/./;
		[ $_, $time ] 
	}
	keys %{ $hashes{ $this } };

#%	print "[@names]\n";

for my $name (@names){
	print "$name - ", $hashes{ $this }{ $name }[0];
	defined $hashes{ $this }{ $name }[1] and do {
		my( $tourn, $time1 ) = split /->/, $hashes{ $this }{ $name }[1];
		my $time0 = $hashes{ $this }{ $name }[0];
		my $diff = eval join '-',
		map {
			my( $min, $sec ) = split /:/;
			$sec =~ s/^0//;
			my $time = $min * 60 + $sec;
			$time;
		} $time0, $time1;
		my $sign = 0 + ( $diff =~ m/-/ );
		$sign =~ y/01/+-/;
		$diff =~ s/-//;
		my $min = int $diff / 60;
		my $sec = $diff - $min * 60;
		$sec = sprintf "%.3f", $sec;
		$sec =~ s/^(?=\d\.)/0/;
		print " (${sign}${min}:${sec}, $tourn: $time1)";
	};
	print "\n";
}


