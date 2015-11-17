$\ = $/;

while(<>){
	chomp,
	$L = length,
	print qw(False True)[$_ == eval join '+', map $_ ** $L, split //]
	}
