$\ = $/;

while(<>){
	chomp;
	/^$/ and next;
	($a, $b) = split '\|';
	@a = split //, $a;
	print join '', map $a[$_-1], @_ = split " ", $b
	}
