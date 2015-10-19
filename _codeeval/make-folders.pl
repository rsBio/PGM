#!/usr/bin/perl

use warnings;
use strict;

# USE: perl make-folders <word> <list>
# e.g. word: 'easy'; e.g.list: 'all-easy'

chomp(
    my ($folder, $list) = @ARGV
);

open my $List , '<', "$list" or die "$0:Can't create:$1\n";

mkdir $folder or die "$0:Can't mkdir:$1\n";
chdir $folder;

my @lines = <$List>;
#% print "[[[@lines]]]\n";

my %status = (
    4 => 'not',
    3 => 'fail',
    2 => 'part',
    1 => 'ok',
);

for (@lines){
    my ($name, $is_solved, $brief_description) = split "\t";
    $name =~ s/ /_/g;
    $is_solved =~ s/[a-z]//ig;

#%    print join " + ", $name, $is_solved, $description; 
#%    print "\n";

    mkdir $name or die "$0:Can't mkdir:$1\n";
    chdir $name;

    open my $out , '>',         'out' or die "$0:Can't create:$1\n";
    open my $in  , '>',          'in' or die "$0:Can't create:$1\n";
    open my $desc, '>', 'description' or die "$0:Can't create:$1\n";
    open my $stat, '>',      'status' or die "$0:Can't create:$1\n";
    open my $code, '>',       "$name" or die "$0:Can't create:$1\n";

    print $stat $status{ 0 + $is_solved };
    print $desc $brief_description;
    chdir '..';
}


