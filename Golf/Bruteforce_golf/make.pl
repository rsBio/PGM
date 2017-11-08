#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

open my $to, '>', "ans.txt" or die "Can't open!\n";
close $to;

@_ = ( '', '{', '}', split //, q{+-*/<=>`"'[]();:,.!?~|^&%} );

my $k = "000";
for my $i ( @_ ){
	for my $j ( @_ ){
	$k ++;
	
	my( $Qi, $Qj ) = map quotemeta, $i, $j;
	
	open my $out, '>', "Rand_prog_test/a$k.pl";

	print $out qq{#!/usr/bin/perl};
	print $out qq{open my \$out, '>>', "ans.txt";};
	print $out qq{print \$out "$k:[$Qi][$Qj]", "\\n";};
	print $out qq{print \$out $i$j;};
	print $out qq{print \$out "\\n";};
	print $out qq{close \$out;};

	close $out;
	
	`perl Rand_prog_test/a$k.pl`;
	}
}