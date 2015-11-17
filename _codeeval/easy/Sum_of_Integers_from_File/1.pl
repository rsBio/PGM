use bigint;
local $/;
$_ = <>;
map $sum += $_, split;
print $sum
