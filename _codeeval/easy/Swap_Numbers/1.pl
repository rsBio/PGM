local $/;
$_ = <>;
print s/(\d)(\w+)(\d)/$3$2$1/rg
