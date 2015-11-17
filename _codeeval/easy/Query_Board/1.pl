$\ = $/;

while(<>){
    ($sq, $rc, $n) = split;
    $k = 0 + /R/;
	
    /S/ &&                      map $a[$k * $rc + !$k * $_][!$k * $rc + $k * $_] = $n, 0 .. 255;
    /Q/ && print eval join '+', map $a[$k * $rc + !$k * $_][!$k * $rc + $k * $_] + 0 , 0 .. 255
	
    }
