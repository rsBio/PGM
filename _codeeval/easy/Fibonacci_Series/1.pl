use bigint;
@_ = (0, 1);
$a = $_[-1], $b = $_[-2], $c = $a + $b, push @_, $c for 1 .. 1e2;
$\ = $/;
print $_[$_] while <>
