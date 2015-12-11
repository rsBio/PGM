#!/usr/bin/perl

use warnings;
use strict;
no warnings 'experimental::smartmatch';

srand;

print "Kiek langelių paslėpti? Už skaičiaus įveskite procento\n"
	. " ženklą, jeigu reikia paslėpti kažkurią dalį nuo visų langelių.\n";

my $hide_nr;
my $percent;

while(<STDIN>){
	if ( /\b(\d+)\b \s* (%)?/x ){
		(defined $2 ? $percent : $hide_nr) = $1;
		last;
	}
}

#%	print "[$percent] <$hide_nr>\n";

while(@ARGV){
	my $file = shift @ARGV;
	open my $fh, '<', $file or die "$0: Can't open $!!\n";

	$_ = do { local $/ ; <$fh> };
	my ($first_line, @lines) = split /\n/;
	my ($len, $n, $m) = split ' ', $first_line;

	if (defined $percent){
		$hide_nr = int( $len ** 2 * $percent * 0.01 );
	}
#%	print "hide_nr: $hide_nr\n";

	my @all_fields = (1 .. $len ** 2);
	my @to_hide;
	push @to_hide, splice @all_fields, rand @all_fields, 1
		for 1 .. $hide_nr;
#%	print "[@to_hide]\n";

	my @all_nums = split ' ', "@lines";
	$all_nums[$_-1] = 0 for @to_hide;
	
	for (1 .. $len ** 2){
		$all_nums[ $_ -1 ] .= $_ % $len ? " " : "\n"
	}
	
	open my $out, '>', "$file-minus-"
		. (defined $percent ? "$percent%" : $hide_nr)
		or die "$0: Can't create $!!\n";
	print $out "$first_line\n", @all_nums, "\n";

}
