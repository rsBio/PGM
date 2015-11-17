while(<>){
    chomp;
    $s = 0;
    map $s += $_, split//;
    print "$s\n"
    }
