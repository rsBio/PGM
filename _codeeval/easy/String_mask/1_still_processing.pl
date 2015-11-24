$\ = $/;
while(<>){
	chomp;
	($a, $b) = split;
	$b = reverse $b;
	$a =~ s/./chop $b ? uc $& : $&/ge;
	print $a
	}
