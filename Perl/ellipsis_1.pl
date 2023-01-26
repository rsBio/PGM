#!/usr/bin/perl

use v5.12;
sub unimplemented { ... }
eval { unimplemented() };
if ($@ =~ /^Unimplemented at /) {
    say "I found an ellipsis!";
}

sub foo { ... }

eval { ... };
sub somemeth {
    my $self = shift;
    ...;
}
my $x = do {
    my $n;
   # ...;
    say "Hurrah!";
    $n;
};

{ ... }
...;