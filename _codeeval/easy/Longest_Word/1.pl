$\ = $/;
while(<>){
	@_ = split;
	$w = $_[0];
	$max = length $_[0];
	for (@_){
		(length) > $max and do { $max = length; $w = $_};
		}
	print $w
	}
