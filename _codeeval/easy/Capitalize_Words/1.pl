local $/;
$_ = <>;
s/\S+/ucfirst $&/ge;
print
