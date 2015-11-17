$\ = $/;
while(<>){
	chomp;
	/./ or next;
	$sum = 0;
	while (/{[^{}]*"id": ?(\d+)[^{}]*, "label":/g){
		$sum += $1
		}
	print $sum
	}
