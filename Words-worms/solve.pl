#!/usr/bin/perl

use warnings;
use strict;
use Time::HiRes qw( usleep );

my $debug = 0;
my $debug2 = 0;
my $debug3 = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $split = "";
my $wall = '*';

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
	/-d/ and $debug = 1;
	/-d2/ and $debug2 = 1;
	/-d3/ and $debug3 = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = grep m/./, (defined $in ? <$in> : <STDIN>);
    chomp @data;
	
	my ($rows, $cols) = split ' ', $data[ 0 ];
	my $area = $rows * $cols;
	
	$debug and print "Area: $area ($rows x $cols)\n";
	my @area;
	push @area, [ ($wall) x ($cols + 2) ];
	push @area, [ $wall, (split /$split/), $wall ] for @data[ 1 .. $rows ];
	push @area, [ ($wall) x ($cols + 2) ];
	$debug and print @{$_}, "\n" for @area;
	
	my $n = $data[ $rows + 1 ];
	my @words = @data[ $rows + 2 .. $rows + 1 + $n ];
	$debug and printf "Num of words: %d\n", 0 + @words;

	my %letters;
	for my $i (1 .. $rows){
		for my $j (1 .. $cols){
			push @{ $letters{ $area[$i][$j] } }, [$i, $j];
		}
	}
	$debug and printf "$_: %s\n", join '', 
		map { "[@{$_}]" } @{ $letters{$_} } for sort keys %letters;
	
	my @seq = map { (map uc, split /\B/) } map { s/^/*/r } @words;
	$debug and print "Seq: [@seq]\n";
	
	my @mem;
	push @mem, [(0) x ($cols + 2)] for 1 .. $rows + 2;
#%	print "<@{$_}>\n" for @mem;

	my @solution;
	my @solution_stack;
	my( $prevx, $prevy ) = (-2, -2);
	my @xy_stack = [$prevx, $prevy];
	my $solved = 0;
	
	go();
	
	sub go {
		return if $solved;
		my $lett = shift @seq;
		my @try = do {
			if( $lett =~ /^\*(\w)/ ){
				@{ $letters{ $1 } };
			}
			else {
				[$prevx + 1, $prevy], [$prevx, $prevy + 1],
				[$prevx - 1, $prevy], [$prevx, $prevy - 1],
			}
		};
		for my $try (@try){
			my ($x, $y) = @{$try};
		#%	print "[$x $y]\n";
			$mem[$x][$y] and next;
		#%	print "[$area[$x][$y] ne $lett]\n";
			$area[$x][$y] ne $lett =~ y/*//dr and next;
			$mem[$x][$y] = $lett =~ s/.$/lc $&/er =~ s/\*(.)/uc $1/er;
			push @xy_stack, [$x, $y];
			($prevx, $prevy) = ($x, $y);
			$debug2 and print 0 + @xy_stack, "\n";
			$debug2 and pretty_print(\@mem, \@xy_stack);
			$debug3 and do {
				usleep(200_000);
				print "\033[2J";    #clear the screen
				print "\033[0;0H"; #jump to 0,0	
				print 0 + @xy_stack, "\n";
				pretty_print(\@mem, \@xy_stack);
			};
		#%	print "<@{$_}>\n" for @mem;
			if( @xy_stack > $area - 0){
				@solution = map { [ @{$_} ] } @mem;
				@solution_stack = map { [ @{$_} ] } @xy_stack;
				$solved = 1;
			}
			return if $solved;
			go();
			return if $solved;
			$mem[$x][$y] = 0;
			pop @xy_stack;
			($prevx, $prevy) = @{ $xy_stack[-1] };
		}
		unshift @seq, $lett;
	}
	
	$debug and print "<@{$_}>\n" for @solution;
	$debug and print "[@{$_}]" for @solution_stack;
	$debug and print "\n";
	
	print $solved ? "SOLVED\n" : "NO SOLUTION\n";
	pretty_print(\@solution, \@solution_stack);

	sub pretty_print {
		my( $ref_to_array, $ref_to_stack ) = (shift, shift);
		my @array = map { [ @{$_} ] } @{$ref_to_array};
		my @stack = map { [ @{$_} ] } @{$ref_to_stack};
	
		@array = map { (
					[ ('+', '-') x ($cols + 2) ],
					[ map { ('|', $_ || ' ') } @{$_} ]
				) } @array;
		for my $i (0 .. @stack - 2){
			my( $x0, $y0 ) = @{ $stack[$i] };
			my( $x1, $y1 ) = @{ $stack[$i+1] };
		##%	print "[$array[$x1 * 2][$y1 * 2]]\n";
			$array[$x1 * 2 + 1][$y1 * 2 + 1] =~ /[A-Z]/ and next;
			if( $x1 - $x0 == 1 and $y1 - $y0 == 0){
				$array[($x0 + 1) * 2][$y0 * 2 + 1] = ' ';
			}
			if( $x1 - $x0 == 0 and $y1 - $y0 == 1){
				$array[$x0 * 2 + 1][($y0 + 1) * 2] = ' ';
			}
			if( $x0 - $x1 == 1 and $y1 - $y0 == 0){
				$array[($x1 + 1) * 2][$y0 * 2 + 1] = ' ';
			}
			if( $x1 - $x0 == 0 and $y0 - $y1 == 1){
				$array[$x0 * 2 + 1][($y1 + 1) * 2] = ' ';
			}
		}
		splice @array, 0, 2;
		pop @array;
		map { splice @{$_}, 0, 2; pop @{$_} } @array;
		print do { local $" = '', "@{$_}\n" } for @array;
	}
}


