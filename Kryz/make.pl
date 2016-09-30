#!/usr/bin/perl

use strict;
use warnings;
no warnings 'uninitialized';

my %H = map { chomp; reverse split /\t/, $_ } grep m/\S/, <>;

#%	print "[$_->$H{$_}]\n" for keys %H;

my @words = map { "0${_}0" } sort { length $b <=> length $a } keys %H;

my $first = shift @words;
my $len_first = length $first;

my ($x, $y) = (50, 50);
my @A;
my @B;
my @Q;

my $copy_first = $first;
for my $i (1 .. $len_first){
    $A[$x - $i][$y] = chop $copy_first;
}
$B[ $x - $len_first ][ $y ] = 'H' . ' ' . $H{ $first =~ s/\d//gr };

my ($lx, $rx) = map { $x - $_ - 1 } $len_first, 0;
my ($uy, $dy) = ($y, $y);


## cycles:
for my $n (1 .. 12){

my @cand = ();

for my $word (@words){
    my $len_word = length $word;
    my @letters = split '', $word;
    for my $xi ($lx .. $rx){
        for my $yj ( $dy - $len_word .. $uy ){
            my $jj = 0;
            my $cnt = 0;
            for my $j ( $yj .. $yj + $len_word - 1 ){
                $A[$xi][$j] =~ /\d/ and do { $cnt = -1 ; last };
                $A[$xi][$j] ne $letters[$jj] and length $A[$xi][$j] and
                    do { $cnt = -1 ; last };
                $cnt += $A[$xi][$j] eq $letters[$jj];
                $jj ++;
            }
            if( $cnt > 0 ){
                push @cand, join ' ', $cnt, $word, 'V', $xi, $yj;
            }
        }
    }

    for my $yj ($dy .. $uy){
        for my $xi ( $lx - $len_word .. $rx ){
            my $ii = 0;
            my $cnt = 0;
            for my $i ( $xi .. $xi + $len_word - 1 ){
                $A[$i][$yj] =~ /\d/ and do { $cnt = -1 ; last };
                $A[$i][$yj] ne $letters[$ii] and length $A[$i][$yj] and
                    do { $cnt = -1 ; last };
                $cnt += $A[$i][$yj] eq $letters[$ii];
                $ii ++;
            }
            if( $cnt > 0 ){
                push @cand, join ' ', $cnt, $word, 'H', $yj, $xi;
            }
        }
    }
}

@cand = reverse sort @cand;
my $cnt = (split ' ', $cand[0])[ 0 ];
@cand = grep m/^$cnt\b/, @cand;

#%	print map "$_\n", @cand;

@cand = sort { area($a) <=> area($b) } @cand;

#%	print map "$_\n", @cand;

my $add = shift @cand;

my (undef, $word, $D, $c1, $c2) = (split ' ', $add);
my $len_w = length $word;

@words = grep $word ne $_, @words;

my $copy_word = $word;
do {
	if ($D eq 'V'){
		for my $j (reverse 1 .. $len_w){
			$A[ $c1 ][ $c2 + $j - 1 ] = chop $copy_word;
		}
		$B[ $c1 ][ $c2 ] = 'V' . ' ' . $H{ $word =~ s/\d//gr };
		my $up = $c2 + $len_w - 1;
		$up = $uy if $uy > $up;
		my $down = $c2 > $dy ? $dy : $c2;
		$uy = $up;
		$dy = $down;
	}
	else {
		for my $i (reverse 1 .. $len_w){
			$A[ $c2 + $i - 1 ][ $c1 ] = chop $copy_word;
		}
		$B[ $c2 ][ $c1 ] = 'H' . ' ' . $H{ $word =~ s/\d//gr };
		my $right = $c2 + $len_w - 1;
		$right = $rx if $rx > $right;
		my $left = $c2 > $lx ? $lx : $c2;
		$rx = $right;
		$lx = $left;
	}
};

}
##end cycles

for my $j ($dy .. $uy){
	for my $i ($lx .. $rx){
		$B[$i][$j] and do { 
			my ($D, $question) = split ' ', $B[$i][$j], 2;
			push @Q, $question;
			print $D;
			print "\t";
			next;
		};
		print $A[$i][$j] 
			=~ s/[a-z]/*/r
			=~ s/0|^$/ /r;
		print "\t";
	}
	print "\n";
}

print "[$_]\n" for @Q;

sub area {
	my ($cnt, $word, $D, $c1, $c2) = (split ' ', shift);
	my $len_w = length $word;
	my $area = do {
		if ($D eq 'V'){
			my $up = $c2 + $len_w - 1;
			$up = $uy if $uy > $up;
			my $down = $c2 > $dy ? $dy : $c2;
			($up - $down + 1) * ($rx - $lx + 1);
		}
		else {
			my $right = $c2 + $len_w - 1;
			$right = $rx if $rx > $right;
			my $left = $c2 > $lx ? $lx : $c2;
			($right - $left + 1) * ($uy - $dy + 1)
		}
	}
}
