$\ = $/;
while(<>){
	$m = 0;
	print join ',', map {$d = $_ - $m; $m = $_; $d} sort {$a <=> $b} /\d+/g;
	}
