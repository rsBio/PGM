$\ = $/;

while(<>){
	($a, $b) = split ';';
	@a = split " ", $a;
	@d = ();
	$d[$_] = 1 for split " ", $b;
	$e = join '', grep !$d[$_], 1 .. @a;
	@c = ();
	map $c[$_-1] = shift @a, (split " ", $b), $e;
	print "@c"
	}
