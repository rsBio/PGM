%h = @h = <DATA> =~ /\b[[:upper:]]\b/g;
$y{$_ x 5} = $h{$_}, $u{ $_ x 4 } = "$_$h{$_}" for keys %h;

while(<>){
	$_ = reverse;
	
	$i = -2;
    s/\d/ $h[$i += 2] x $& /ge;
    
    $_ = reverse;
    
    for $m (keys %y){
    	s/$m/$y{$m}/
    	}
    	
    for $m (keys %u){
    	s/$m/$u{$m}/
    	}
    
    s/VIV/IX/;
    s/LXL/XC/;
    s/DCD/CM/;
    
	print
    }
    
__DATA__
The symbols I (capital i), V, X, L, C, D, and M
