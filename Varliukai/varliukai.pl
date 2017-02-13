#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my( $V, $H ) = ( 30, 15 );
my @frogs = '01' .. '11';
my $bg = '.';
my $frog = 'x';
my $mark = 'm';
my $explo = '?';
my $speed = 5;
my $add_freq = 3;
my $rotated = 0;
my $added = 0;
my @axisH;
my @axisV;
my %hitH;
my %hitV;

for (@opt){
	/-bg=(.)$/ and do {
		$bg = $1;
	};
	/-explo=(\S)$/ and do {
		$explo = $1;
	};
	/-mark=(\S)$/ and do {
		$mark = $1;
	};
	/-V(\d+)/ and do {
		$V = $1;
	};
	/-H(\d+)/ and do {
		$H = $1;
	};
	/-speed(\d+)/ and do {
		$speed = $1;
	};
	/-add-freq(\d+)?/ and do {
		$add_freq = $1;
	};
	/-d$/ and $debug = 1;
}

@ARGV = @ARGV_2;

$debug and print "@frogs\n";

my %frog;

for my $frog_nr (@frogs){
	open my $in, '<', "frog-${frog_nr}.pgm" 
		or die "$0: Can't open [frog-${frog_nr}.pgm]: $!\n";
	<$in>; # skip P2
	my( $frogV, $frogH ) = split ' ', <$in>;
	my( $maxval ) = split ' ', <$in>;
	my @lines = map { s/\s//gr } <$in>;
	my $re = join '.' x ( $V - $frogV + 0 ) . ( $debug ? "\n" : ''), 
		map { s/0/./gr =~ s/[^.]/$frog/gr } @lines;
	
	$debug and print "$re\n";
	$debug and $re =~ s/\n//g;
	
	$frog{ $frog_nr }{ 're' } = $re;
	$frog{ $frog_nr }{ 'V' } = $frogV;
	$frog{ $frog_nr }{ 'H' } = $frogH;
	$frog{ $frog_nr }{ 'maxval' } = $maxval;
	}

my $A;

#!	my @A = map { [ ($bg) x $V ] } 1 .. $H;
	my @A = map { $bg x $V } 1 .. $H;

#!	print "@$_\n" for @A;
	print "$_\n" for @A;

my @initT;

@initT[ 0 .. 2 ] = localtime();
my $initT = $initT[ 0 ] * 1 + $initT[ 1 ] * 60 + $initT[ 2 ] * 3600;
$debug and print "[@initT|$initT]\n";

my $gameover = 0;

goto START;

while( <> ){
	chomp;
	my( $v, $h ) = split;
	
	my @nowT;
	@nowT[ 0 .. 2 ] = localtime();
	my $nowT = $nowT[ 0 ] * 1 + $nowT[ 1 ] * 60 + $nowT[ 2 ] * 3600;
	$debug and print " [@nowT|$nowT]\n";	
	
	print $nowT - $initT, "\n";
	
	# rotatinam pagal laika:
	
	for my $times ( 1 .. ( $nowT - $initT ) / $speed - $rotated ){
		my $last = pop @A;
		$last =~ /$frog/ and $gameover = 1;
		unshift @A, $bg x $V;
		$rotated ++;
		}
	
	if( $gameover ){
		print "GAME OVER!\n";
		last;
		}
	
	# saunam i varles:
	
	for my $i (0 .. @axisH - 1){
		$axisH[ $i ] =~ s/\s+//r ne $h and next;
		$hitH{ $i } = 1;
		$hitH{ $i-1 } = 1 if $i-1 >= 0;
		$hitH{ $i+1 } = 1 if $i+1 < $H;
		}
	print map "hitH:[$_]\n", join ' ', sort keys %hitH;
	
	for my $i (0 .. @axisV - 1){
		$axisV[ $i ] ne $v and next;
		$hitV{ $i } = 1;
		$hitV{ $i-1 } = 1 if $i-1 >= 0;
		$hitV{ $i+1 } = 1 if $i+1 < $V;
		}
	print map "hitV:[$_]\n", join ' ', sort keys %hitV;
	
	for my $hh ( sort keys %hitH ){
		for my $vv ( sort keys %hitV ){
			substr $A[ $hh ], $vv, 1, $explo;
			}
		}
	for my $i (0 .. @A - 1){
		print "$axisH[$i]|$A[$i]\n";
		}
	print "  +" . '-' x $V, "\n";
	print "   ", @axisV, "\n";
	
	undef %hitH;
	undef %hitV;
	
	my $B = 0;
	$B++ for 1 .. 1e7;
	
	my $qm = quotemeta $explo;
	s/${qm}/$bg/g for @A;
	
	# ar gali tilpti nauja varle ?? :
	
	START: 
	
	my $inserted = 0;
	if( $rotated - $added * $add_freq <= 0 ){ $inserted = 1; }
	
	my $try = 0;
	while( ! $inserted ){
		$try ++ > 30 and last;
		my $try_frog = ( keys %frog )[ rand keys %frog ];
		$debug and print ":$try_frog\n";
		my( $ins_V, $ins_H ) = ( int rand $V - $frog{ $try_frog }{ 'V' }, int rand $H / 3 );
		$debug and print "my( $ins_V, $ins_H )\n";
		
		$A[ $ins_H ] =~ s/.{$ins_V}\K/$mark/ or next;
		
		$debug and print "!!\n";
		
		$A = join "", @A;
		
		$debug and print $A;
		
		my $re = $frog{ $try_frog }{ 're' };
		my $re2 = $re;
		$re2 =~ s/$frog/[^$frog]/g;
		$debug and print "\n$re2\n";
		
		if( $A =~ /${mark}\K$re2/s ){
			$debug and print "ok\n";
			my $matched = $&;
			my $to_upd = '';
			my $re3 = $re;
			
			while( $matched =~ /./gs ){
				my $match = $&;
				$re3 =~ s/.//s;
				my $re3f = $&;
				$to_upd .= $re3f eq '.' ? $match : $re3f;
				}
			
			$A =~ s/${mark}$re2/$to_upd/s;
			}
		else { $A[ $ins_H ] =~ s/${mark}// ; next }
			
		@A = $A =~ /.{$V}/g;
		
		$debug and print "AAAAAA\n";
		$inserted = 1;
		$added ++;
		}
	
	@axisH = map { sprintf "%2d", int rand $H } 1 .. $H;
	@axisV = map { sprintf "%s", ('a' .. 'z')[rand 26] } 1 .. $V;
	
##	print "|$_\n" for @A;

	for my $i (0 .. @A - 1){
		print "$axisH[$i]|$A[$i]\n";
		}
	print "  +" . '-' x $V, "\n";
	print "   ", @axisV, "\n";
	
	}
