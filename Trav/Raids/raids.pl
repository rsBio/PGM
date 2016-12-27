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
	/-topbm/ and do {
		#$to_pbm = 1;
	};
	/-topgm/ and do {
		#$to_pgm = 1;
	};
	/-d/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	local $/;
	my $data = (defined $in ? <$in> : <STDIN>);
	
	my $logcnt = () = $data =~ /^Tema:/gm;
	print "LOGCNT:$logcnt\n";
	
	my $matchcnt = () = $data =~ /^Tema: .{1,44}? Laisva[ ]oaz/gmxs;
	print "MATCHCNT:$matchcnt\n";
	
	my @matches = $data =~ /^Tema: .{1,88} /gmxs;
	$debug and print join "\n", @matches;
	
	my @logs;
	my @AoH;
	
#	$data =~ s/\s(?![ \t\n])//xgms;
#	print $data;
	
	while( $data =~ /
		^Tema: .{1,88}? Laisva[ ]oaz .{1,22}? 
		\( 
		#	.{0,22}?
		#!!! -> "bug'as", kad nesigauna teigiamo skaciaus sumatchint, nors yra '-?'.
			(?<x>
		#	-‭? 
		#	.{0,55}? 
		#	\d+
			.{1,22}
			) 
		.{0,22}? 
		\| 
			(?<y> .{1,22}) 
			.{0,22}?
		\)
		.{0,55}?
		(?<time>\d\d\/\d\d\/\d\d,\s\d{2}:\d{2}:\d{2})
		.{1,333}?
		^Kariai(?<kariai1>(?:\s\d+)+) .{1,22}?
		^Aukos(?<aukos1>(?:\s\d+)+)
		.{1,22}?
		Mediena(?<med>\d+) .{1,22}?
		Molis(?<mol>\d+) .{1,22}?
		is(?<gel>\d+) .{1,22}?
		dai(?<gru>\d+) .{1,22}?
		Talpa(?<grobis>\d+)\/(?<talpa>\d+)
		.{1,222}?
		^Kariai(?<kariai2>(?:\s\d+)+) .{1,22}?
		^Aukos(?<aukos2>(?:\s\d+)+)
	#	(?{print "<<<$&>>>\n"})
		(*ACCEPT)
		/xgms ){
			
		push @logs, $&;
	
		push @AoH, {
			map { my $val = $+{$_}; $_ => $val =~ /\t/ ? [ split ' ', $val ] : $val }
			qw(x y time kariai1 aukos1 
				med mol gel gru
				grobis talpa
				kariai2 aukos2
				)
			};
	#	print "\n";
		
	}
	
	print 0 + @logs, "\n";
	
	my $bal;
	my $cumbal = 0;
	
	for my $log (@AoH) {
		print "$log->{'time'}: ";
		print map "($_)", join '|', map { sprintf "%4s", $log->{$_} =~ s/[^-\d]//gr } qw(x y);
		print " ";
		print map "[$_]", join '', map { sprintf "%5d", $log->{$_} } qw(med mol gel gru);
		print map "[$_]", join '/', map { sprintf "%6d", $log->{$_} } qw(grobis talpa);
	#	print "@{ $log->{'kariai1'} }";
		printf "-Perk:%2d", $log->{'aukos1'}[3];
		printf ",-res:%6d", 1090 * $log->{'aukos1'}[3];
		printf ",bal:%6d", $bal = $log->{'grobis'} - 1090 * $log->{'aukos1'}[3];
		printf ",cumbal:%7d", $cumbal += $bal;
		print "\n";
	}
#	print "[[[\n$_\n]]]\n" for @logs;
}