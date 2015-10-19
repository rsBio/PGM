while(<>){
    $i = 0;
    s/\w/ ++ $i % 2? uc $& : lc $&/ge;
    print
    }
