$\ = $/;

while(<>){
	$_ = abs eval join '-', map {$i = 0; $m = 0; map { s/^0+// ; $m += 60 ** $i ++* $_} reverse split ':'; $_ = $m} split;
	$s = $_ % 60; 	$_ = int ($_ /= 60);
	$m = $_ % 60; 	$_ = int ($_ /= 60);
	printf "%02d:%02d:%02d\n", $_, $m, $s;
	}
