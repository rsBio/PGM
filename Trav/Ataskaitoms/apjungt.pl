#!/usr/bin/perl

use warnings;
use strict;

my $debug = 0;

my @ARGV_2;
my @opt;

for (@ARGV){
	/^-\S/ ? (push @opt, $_) : (push @ARGV_2, $_);
}

my $split = "\t";
my $join = "\n";

for (@opt){
	/-tsv/ and do {
		$split = "\t";
	};
	/-csv/ and do {
		$split = ',';
	};
	/-cssv/ and do {
		$split = ', ';
	};
	/-ssv/ and do {
		$split = ' ';
	};
	/-d$/ and $debug = 1;
}

@ARGV = @ARGV_2;

for (@ARGV){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my $data = do { local $/; defined $in ? <$in> : <STDIN> };
	
	@_ = $data =~ /
		Aukos(?:\t\d+)+\n
		(?:Belaisviai|Informacija)
		.*?
		(?=Grobis)
	/sgx;
	
	s/
		(Nurodytas .*? \n)
		
	/---$1\t/sgx
		for @_;

	s/
		Aukos(?:\t\d+)+\n
		Informacija
	
	//sgx
		for @_[1 .. $#_];
	
#%	print @_;
	
	$data =~ /Tema: .*? Lojalumas/sx;
	$data = $&;
	$data =~ s/Aukos .*? (?=Grobis|Besiginantis)/join "\t+\n", @_/sex;
    $data =~ s/Buvo pasirinktas atsitiktinis taikinys\./($&)/g;
	$data =~ s/(\b.{3,50}) \b\1/$1/sg;

	print $data, "\n";
}
