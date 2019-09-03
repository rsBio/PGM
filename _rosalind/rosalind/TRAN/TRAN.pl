#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

{ local $/ ; $_ = <> };

my( undef, @DNAs ) = split /\>/;

s/.*// for @DNAs;
s/\s//g for @DNAs;

my $cnt_transitions = 0;
my $cnt_transversions = 0;

$DNAs[ 0 ] =~ /	
	.
	(?{
		my $A = $&;
		$DNAs[ 1 ] =~ m!.!g;
		my $B = $&;
		$cnt_transitions += "$A$B" =~ m!AG|GA|CT|TC!;
		$cnt_transversions += "$A$B" =~ m![AG][CT]|[CT][AG]!;
		})
	(*F)
	/x;


print $cnt_transitions / $cnt_transversions;
