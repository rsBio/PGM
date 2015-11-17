$\ = $/;

while(<>){
    chomp;
	($a, $b) = split ';';
	%h = map {$_, 1} split ",", $a;
	print join ",", grep $h{$_}, split ",", $b
	}

