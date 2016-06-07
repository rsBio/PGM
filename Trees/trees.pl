#!/usr/bin/perl

use warnings;
use strict;

sub findxy {
    my( $Ax, $Ay, $Bx, $By, $ab, $ac, $bc ) = @_;
    my( $x, $y ) = (0, 0);
    $step = 1;
    while( $step > 0.01 ){
        $ref_closer = 
        (
        sort {
            my( $x1, $y1 ) = @{ $a };
                $a =
                $ac - sqrt( ($Ax - $x1)**2 + ($Ay - $y1)**2 ) + 
                $bc - sqrt( ($Bx - $x1)**2 + ($By - $y1)**2 );
            my( $x2, $y2 ) = @{ $b };
                $b = 
                $ac - sqrt( ($Ax - $x2)**2 + ($Ay - $y2)**2 ) + 
                $bc - sqrt( ($Bx - $x2)**2 + ($By - $y2)**2 );
            
            $a <=> $b
            }
        [ $x + $step, $y + $step ],
        [ $x + $step, $y - $step ],
        [ $x - $step, $y + $step ],
        [ $x - $step, $y - $step ],
        )[ 0 ];
        
        ($x, $y) = @{$ref_closer};
        print "[$x|$y]\n";
        $step *= 0.7;
    }
}

#print findxy( $Ax, $Ay, $Bx, $By, $ab, $ac, $bc );
print findxy( 0, 0, 2, 0, 2, 3, 3 );
