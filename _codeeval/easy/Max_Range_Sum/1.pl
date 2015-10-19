$\ = $/;

while(<>){
	@a = ();
	($a, @_) = split /[; ]/;
	$a[0] += $_[$_] for 0 .. $a -1;
	($a[$_+1] -= $_[$_]) += $_[$_+$a] + $a[$_] for 0 .. @_ - $a;
	$max = 0;
	$max < $_ and $max = $_ for @a;
	print $max;
	}
