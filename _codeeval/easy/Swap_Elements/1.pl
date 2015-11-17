$\ = $/;
while(<>){
	($arr, $swap) = split ":";
	@_ = split ' ', $arr;
	@swap = split ',', $swap;
	for $sw (@swap){
		($a, $b) = split '-', $sw;
		$tmp = $_[$a]; $_[$a] = $_[$b]; $_[$b] = $tmp
		}
	print "@_"
	}
