$\ = $/;
while(<>){
    ($x, $y, $n) = split;
    $_ = join ' ', map {$_ % $y ? $_ : "${_}B"} map {$_ % $x ? $_ : "${_}F"} 1 .. $n;
    s/\d+(?=[FB]+)//g;
    print
    }
