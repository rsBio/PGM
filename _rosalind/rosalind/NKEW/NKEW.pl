#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

$\ = $/;

my @costs;

while(<>){
	chomp;
	next if not length;
	
	s/;//;
	
	$debug and print "-" x 15;
	
	$debug and print;
	
	my( $u, $v ) = split ' ', <>;
	
	$debug and print "u($u) --> v($v)";
	
	my %h;
	
	my $dummy_name = 'a';
	
	s/(\b$u\b)/-/;
	s/(\b$v\b)/=/;
	
	$debug and print;
	
	s/(\b(?!\d)\w+\b)/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$dummy_name;
		/ge;
	
	s/\)\K(?!\w|-|=)/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$dummy_name;
		/ge;
	
	s/\(\K(?=:)/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$dummy_name;
		/ge;
	
	s/,\K(?=:)/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$dummy_name;
		/ge;
	
	$debug and print;
	
	s/-/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$u = $dummy_name;
		$dummy_name;
		/ge;
	
	s/=/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$v = $dummy_name;
		$dummy_name;
		/ge;
	
	$debug and print "u($u) --> v($v)";
	
	my %g;
	
	0 while 0
		or ( 0 * ( $debug and print "[$_]" ) )
		or s/\( ( [^()]+ ) \) (\w+)((?::\d+\b)?)
			(?{ 
				for my $leaf_w ( split ',', "$1" ){
					my( $leaf, $w ) = split ':', $leaf_w;
					
					$g{ $leaf }{ $2 } = $w;
					$g{ $2 }{ $leaf } = $w;
					}
				}) 
			/$2$3/xg
		;
	
	$debug and print;
	
	$debug and do {
		for my $u ( keys %g ){
			print " $u:";
			for my $v ( keys %{ $g{ $u } } ){
				print "  $v:[$g{ $u }{ $v }]";
				}
			}
		};
	
	my @u = ( $u );
	my %cost;
	$cost{ $u } = 0;
	
	while( 1 ){
		
		if( grep exists $g{ $_ }{ $v }, @u ){
			my $i;
			for my $u ( @u ){
				next if not exists $g{ $u }{ $v };
				$i = $u;
				}
			$cost{ $v } = $cost{ $i } + $g{ $i }{ $v };
			last;
			}
		
		my @new_u;
		
		for my $u ( @u ){
			my @v = keys %{ $g{ $u } };
			$cost{ $_ } = $cost{ $u } + $g{ $u }{ $_ } for @v;
			delete $g{ $u }{ $_ }, delete $g{ $_ }{ $u } for @v;
			
			push @new_u, @v;
			}
		
		@u = @new_u;
		}
	
	$debug and print "cost:[$cost{ $v }]";
	
	$debug and do {
		for my $v ( keys %cost ){
			print " $v:[$cost{ $v }]";
			}
		};
	
	push @costs, $cost{ $v };
	}

print "@costs";