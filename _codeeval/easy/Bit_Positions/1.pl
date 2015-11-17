$\ = $/;
while(<>){
	chomp;
    ($e, $s, $f) = split ',';
    $e = sprintf "%020b", $e;
    $e = reverse $e;
    print ((substr $e, $s-1, 1) == (substr $e, $f-1, 1) ? 'true' : 'false')
    }
