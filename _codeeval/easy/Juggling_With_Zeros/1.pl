$\ = $/;
while(<>){
    chomp;
    s/0(0)? (0+)/(defined $1 ? 1 : 0) x length $2/ge;
    s/ //g;
    print eval "0b$_"
    }
