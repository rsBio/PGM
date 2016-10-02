#!/usr/bin/perl

use warnings;
use strict;

$\ = $/;

open my $table, '<', 'table.trav' or die "$0: ... $!\n";
open my $gyvunai, '<', 'gyvunai.trav' or die "$0: ... $!\n";

my %Table = ();
my @idxs = ();
for (<$table>){
    push @idxs, (split)[0];
    $Table{ (split)[0] } = [ (split) ];
}

#    print "@{ $Table{ 'Cro' } }";

my %Oases = ();

my $data = 0;
my $current;

while( <$gyvunai> ){
    /^M$/ and $data = 1;
    $data or next;
    if( /^[A-Z]+$/ ){
        $current = $&;
    }
    else {
        $Oases{ $current } ||= [];
        push @{ $Oases{ $current } }, $_;
    }
}

#   print @{ $Oases{ 'GC' } };

for my $key (sort keys %Oases){
    my ($di, $dc) = (0) x 2;
    for ( @{ $Oases{ $key } } ){
        my $i = -1;
    #    print;
        for (split){
            $i ++;
        #    print $idxs[$i];
            $di += $Table{ $idxs[$i] }[ 2 ] * $_;
            $dc += $Table{ $idxs[$i] }[ 3 ] * $_;
        }
    }
    printf "%-3s: ", $key;
    printf "[$di|$dc]";
    printf "  %.2f\n", $di / $dc;
}




