#!/usr/bin/perl

use warnings;
use strict;

my $var = qr/[A-Z]\w*/;
my $num = qr/\d+/;

while(<>){
	chomp;
	my %atoms = map { $_, 1 } m/$var/g;
	my @atoms = keys %atoms;
	my $atoms = @atoms;

	print "\nNEW line: [$_]\n";
#%	print "[@atoms]\n";
	my $op;

	my @bools;
	my $line = $_;
	
	for my $i (0 .. -1 + 2 ** $atoms){
		my $_vars = $line;
		my @my_atoms = @atoms;
		map {
			my $atom = shift @my_atoms;
#%			print "[$_]->> $atom\n";
			$_vars =~ s/\b $atom \b/$_/gx
		} split //, sprintf "%0${atoms}b", $i;
		
		$_ = $_vars;
		print ">>$_<<\n";
		
		# regexes follows according precedence of logical ops
		while( 0
			|| ( s/\(( *$num *)\)/ $1 /g , 0 )
			|| (not print "::$_\n") 
			|| s/~( *)($num)/ ' '. $1 . ( 0 + ! $2 ) /e
			|| s/($num)( *)([|&^])( *)($num)/
				$op = $3,
				' '. $2 . 
				( 0 + do {
					if (0){ ; }
					elsif ($op eq '^' ){ $1 xor $5 }
					elsif ($op eq '|' ){ $1 or $5 }
					elsif ($op eq '&' ){ $1 and $5 }
				}
				)
				. $4 . ' '
			   /e
			|| s/($num)( *)(->)( *)($num)/
				' '. $2 . ' '. ( 0 + (not $1 or $5) ) . $4 . ' '
			    /e
		){
			my $len = length $&;
			my $fin = $+[0];
			print '::' . ' ' x ($fin - $len) . '-' x $len . "\n";
		}
		m/^ *(\d) *$/ ?
			(push @bools, $1)
		:
			print "ERROR!\n";
	}
	print "Line '$line' is " 
		. ( (grep ! $_, @bools) ? "NOT " : "")
		. "a tautology! (@bools)\n";
}
