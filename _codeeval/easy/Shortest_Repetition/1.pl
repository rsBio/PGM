$\ = $/;
while(<>){
	chomp;
	$a = $_;
	$a =~ /^(?=(.{$_}))\1+$/ 
	and do {print ; last} for 1 .. 80;
	}
