$\ = $/;

while(<>){
	$L = sqrt length join '', split;
	@_ = split;
	print join " ", map {$x = $_; map $_[-1 + $x + ($_-1) * $L], reverse 1 .. $L} 1 .. $L
	}
