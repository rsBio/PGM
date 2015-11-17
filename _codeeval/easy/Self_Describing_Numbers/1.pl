$\ = $/;
while(<>){
    chomp;
    undef %h;
    map $h{$_} += 1, split //;
    $i = 0;
    $f = 0;
    s/./ ($h{$i} == $& or $f ++), $i++, '' /ge;
    print 1 - !! $f
    }
