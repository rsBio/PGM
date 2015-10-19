$\ = $/;

while(<>){
	chomp;
	($a, $b) = split //;
	$a = index ((join '', '_', a .. h), $a);
	@_ = ();
	for $i (-2 .. 2){
		for $j (-2 .. 2){
			(abs $i) + (abs $j) == 3 or next;
			$i == 0 or $i == 3 and next;
			push @_, "$i $j"
			}
		}

	@m = ();
	$aa = $a + (split)[0], 
	$bb = $b + (split)[1],
	$aa > 0 and $aa < 9 and
	$bb > 0 and $bb < 9 and
	push @m, (undef, a .. h)[$aa] . "$bb"
	for @_;
	
	@m = sort @m;
	print "@m"
	
	}
