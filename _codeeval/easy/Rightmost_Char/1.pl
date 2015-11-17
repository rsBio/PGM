$\ = $/;
while(<>){
    chomp;
    /^$/ and next;
    ($S, $t) = split ',';
    undef $pos;
    while ($S =~ /$t/g){
        $pos = pos $S
        }
    print defined $pos ? $pos -1 : -1
    }
