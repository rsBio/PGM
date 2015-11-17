$\ = $/;

while(<>){
	%h = ();
	@_ = split;
	map $h{$_}++, split;
	$a = (sort {$a <=> $b} grep $h{$_} == 1, keys %h)[0];
	$j = 0;
	$f = 0;
	for $i (@_){
		$j ++;
		$i == $a and ++$f and last;
		}
	print $j * $f
	}
