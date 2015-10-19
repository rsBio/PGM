while(<>){
	print s!\.\d+! $f = $& * 60, $e = $f, ($f = int $f), $e -= $f, $e *= 60, $e += 0.0, ($e = int $e), sprintf ".%02d'%02d\"", $f, $e !ger
	}
