$\ = $/;

while(<>){
	($a, $b) = split /,/, join '', split;
	while ($a - 1e12 * $b > -1){$a -= $b * 1e12};
	while ($a - 1e9 * $b > -1){$a -= $b * 1e9};
	while ($a - 1e6 * $b > -1){$a -= $b * 1e6};
	while ($a - 1e3 * $b > -1){$a -= $b * 1e3};
	while ($a - 1e0 * $b > -1){$a -= $b * 1e0};
	print $a;
	}
