#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

$\ = $/;

my @distances;

while(<>){
	chomp;
	next if not length;
	
	s/;//;
	
	$debug and print "-" x 15;
	
	my( $u, $v ) = split ' ', <>;
	
	my %h;
	
	my $dummy_name = 'a';
	
	s/(\b$u\b)/-/;
	s/(\b$v\b)/=/;
	
	$debug and print;
	
	s/(\b\w+\b)/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$dummy_name;
		/ge;
	
	s/\)\K(?!\w|-|=)/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$dummy_name;
		/ge;
	
	s/\(\K(?=\))/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$dummy_name;
		/ge;
	
	s/,\K(?=\))/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$dummy_name;
		/ge;
	
	s/,\K(?=,)/
		$dummy_name ++ while exists $h{ $dummy_name };
		$h{ $dummy_name } = 1;
		$dummy_name;
		/ge;
	
	s/\(\K(?=,)/
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
	
	my %g;
	
	0 while 0
		or ( 0 * ( $debug and print "[$_]" ) )
		or s/\( ( [^()]+ ) \) (\w+\b) 
			(?{ $g{ $_ }{ $2 } ++, $g{ $2 }{ $_ } ++ for split ',', "$1";
				}) 
			/$2/xg
		;
	
	$debug and print;
	
	my @u = ( $u );
	
	my $distance = 1;
	
	while( 1 ){
		
		if( grep exists $g{ $_ }{ $v }, @u ){
			last;
			}
		
		my @new_u;
		
		for my $u ( @u ){
			my @v = keys %{ $g{ $u } };
			delete $g{ $u }{ $_ }, delete $g{ $_ }{ $u } for @v;
			
			push @new_u, @v;
			}
		
		@u = @new_u;
		
		$distance ++;
		}
	
	$debug and print $distance;
	push @distances, $distance;
	}

print "@distances";