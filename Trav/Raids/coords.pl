#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $split = "\t";
my $join = "\n";
my $print_values = 0;
my $H;
my $print_H = 0;
my $pList;

for (@opt){
	/-pv/ and do {
		$print_values = 1;
	};
	/-H(\S+)/ and do {
		$H = [ split ',', "$1" ];
	};
	/-pH/ and do {
		$print_H = 1;
	};
	/-p:(\S+)/ and do {
		$pList = $1;
	};
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
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { chomp; [ split /$split/ ] } grep m/./, (defined $in ? <$in> : <STDIN>);
	
	my $j_all = shift @data;
	shift @{$j_all};
	
	my @records;
	my %values;
	
	for my $line (@data){
		
		my $i = shift @{$line};
		
		for my $j (@{$j_all}){
			my $value = shift @{$line};
			
			next if not length $value;
			
			push @records, { 'y' => $i, 'x' => $j, 'v' => $value };
			
			$values{ $value } ++;
			}
		}
	
	if( not defined $H ){
		for my $r (@records){
			$r->{'v'} eq 'H' and $H = [ $r->{'x'}, $r->{'y'} ];
			}
		}
	
	if( $debug or $print_values ){
		print "H:[@{$H}]\n";
		} 
	
	if( $debug or $print_values ){
		print join "\n",
			map { "$_ -> $values{$_}" }
			sort { $values{$b} <=> $values{$a} } keys %values;
		print "\n";
		}
	
	my @sorted = 
	map { [ $_->[0], $_->[1], $_->[2], (sprintf "%.3f", $_->[3]) ] }
	sort { $a->[3] <=> $b->[3] }
	map { 
		my $minX = ( sort { abs $a <=> abs $b } 
			$_->{'x'} - 801 - $H->[0],
			$_->{'x'} -   0 - $H->[0],
			$_->{'x'} + 801 - $H->[0],
		)[ 0 ];
		my $minY = ( sort { abs $a <=> abs $b } 
			$_->{'y'} - 801 - $H->[1],
			$_->{'y'} -   0 - $H->[1],
			$_->{'y'} + 801 - $H->[1],
		)[ 0 ];
		
		[ $_->{'x'}, $_->{'y'}, $_->{'v'}, 
		sqrt( ($minX) ** 2 + ($minY) ** 2 ),
		] 
		}
	@records;
	
	if( defined $pList ){
		
		$pList =~ s/,/|/g;
		print "pList: $pList\n";
		@sorted = grep { $_->[ 2 ] =~ /$pList/ } @sorted;
		
		}

	for my $r (@sorted){
		print join " ", @{$r}[3, 2, 0, 1];
			
		print "\n";
	}
}
