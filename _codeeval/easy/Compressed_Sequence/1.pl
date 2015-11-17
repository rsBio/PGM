$\ = $/;

while(<>){
	chomp;
	@_ = ();
	while (/(\b\d+\b)( \1\b)*/g){
		$e = $&;
		$f = $1;
		$ce = () = $e =~ / /g;
		push @_, $ce +1, $f
		}
	print "@_"
	}
