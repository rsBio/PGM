$\ = $/;
while(<>){
    chomp;
    $L = length;
    $lc = () = /[a-z]/g;
    $uc = () = /[A-Z]/g;
    printf "lowercase: %.2f uppercase: %.2f\n", map 100 * $_ / $L, $lc, $uc
    }
