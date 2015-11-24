$\ = $/;
while(<>){
	chomp;
	s/\W//g;
	y/A-Z/a-z/;
	%h = ();
	map $h{$_} += 1, split //;
	@val = sort {$b <=> $a} values %h;
	$n = 26;
	$sum = 0;
	while (@val){
		$sum += $n --* (shift @val)
		}
	print $sum;
	}
