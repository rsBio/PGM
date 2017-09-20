#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @FILES;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @FILES, $_);
}

my $split = " ";
my $join = " ";

for (@opt){
	/-tsv/ and do {
		$split = "\t";
	};
	/-csv/ and do {
		$split = ',';
	};
	/-cssv/ and do {
		$split = ', ';
	};
	/-ssv/ and do {
		$split = ' ';
	};
	/-nosep/ and do {
		$split = '';
	};
	/-totsv/ and do {
		$join = "\t";
	};
	/-tocsv/ and do {
		$join = ',';
	};
	/-tocssv/ and do {
		$join = ', ';
	};
	/-tossv/ and do {
		$join = ' ';
	};
	/-tonosep/ and do {
		$join = '';
	};
	/-d$/ and do {
		$debug = 1;
	};
}

sub to_sec {
	my $h_m_s = shift;
	my( $s, $m, $h ) = reverse split /:/, $h_m_s;
	return $s + $m * 60 + ( defined $h ? $h * 3600 : 0 );
	}

sub to_h_mm_ss {
	my $secs = shift;
	my $ss = sprintf "%02d", $secs % 60;
	$secs = int $secs / 60;
	my $mm = sprintf "%02d", $secs % 60;
	$secs = int $secs / 60;
	my $h = $secs;
	return( ( join ':', $h, $mm, $ss ) =~ s/^://r );
	}
	
for (@FILES){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; $_ } 
		grep m/./, (defined $in ? <$in> : <STDIN>);
	
	my $first_finish_place = $data[ 0 ];
	
	my $finish_place;
	my $team;
	my %h;
	
	for ( @data ){
		$debug and print "line:[$_]\n";
		
		/^(\d+)$/ and do {
			$finish_place = $1;
			next;
			};
		
		/^\s/ and do {
			s/^\s+(.*?),\s(.*?)\s+(\w{3})\s+(\d+:\d+:\d+)\s+\b//;
			$team = $1;
			$h{ $team }{ town } = $2;
			$h{ $team }{ country } = $3;
			$h{ $team }{ finish_time } = $4;
			$debug and print "team:[$team], town:[$h{ $team }{ town }], " .
				"country:[$h{ $team }{ country }], finish_time:[$h{ $team }{ finish_time }]\n";
			$h{ $team }{ finish_place } = $finish_place;
			redo;
			};
		
		/^\d+\s+.*?(\d*:?\d\d:\d\d)/ and do {
			my $h_m_s = $1;
			$debug and print "h_m_s:[$h_m_s]\n";
			$h{ $team }{ team_time_acc } += to_sec( $h_m_s );
			next;
			};
		
		die "Can't match line:[$_]!\n";
		}
	
	for my $team ( sort keys %h ){
		$debug and print $team, ' -> ', $h{ $team }{ team_time_acc }, "\n";
		}
	
	print map "$_\n", map {
		join $join, 
			$first_finish_place ++,
			$_ . ', ' . $h{ $_ }{ town }, 
			$h{ $_ }{ country },
			to_h_mm_ss( $h{ $_ }{ team_time_acc } ),
			$h{ $_ }{ finish_place },
			$h{ $_ }{ finish_time },
		} sort { $h{ $a }{ team_time_acc } <=> $h{ $b }{ team_time_acc } } keys %h;
	
}
