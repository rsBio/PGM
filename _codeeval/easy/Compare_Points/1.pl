$\ = $/;

while(<>){
	($x, $y, $X, $Y) = split;
	$_ = q(SNWE);
	$re = qw(WE E W)[$x - $X <=> 0];
	s/$re//;
	$re = qw(SN N S)[$y - $Y <=> 0];
	s/$re//;
	$_ ||= here;
	print
	}
