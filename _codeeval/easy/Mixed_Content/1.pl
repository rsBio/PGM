$\ = $/;

while(<>){
	chomp;
	$_ = join '|', (join ',', grep /\D/, split ','), (join ',', grep /\d/, split ',');
	s/^\|//;
	s/\|$//;
	print
	}
