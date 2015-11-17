$\ = $/;
while(<>){
    chomp;
    undef %h;
    while (not exists $h{$_}){
    	$h{$_} = 1;
        $_ = eval join '+', map $_ ** 2, split //;
        exists $h{1} and last
        }
	print 0 + !! $h{1}
    }
