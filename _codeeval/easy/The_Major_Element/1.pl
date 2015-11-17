$\ = $/;
while(<>){
    chomp;
    %h = ();
    @_ = split /,/;
    $max =-~0;
    ++ $h{$_}, $h{$_} > $max and ($max = $h{$_}, $m = $_) for @_;
    print $max > @_ / 2 ? $m : "None"
    }
