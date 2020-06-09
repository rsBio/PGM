#!/usr/bin/perl

use warnings;
use strict;

no warnings qw( uninitialized );

my $debug = 0;

my @FILES;
my @opt;

for( @ARGV ){
	/^-\S/ ? ( push @opt, $_ ) : ( push @FILES, $_ );
}

my $split = "\t";
my $join = "\t";
my $countries_file = 'countries.txt';
my $meta_file = 'meta.txt';

my $event_day_re;
my $start_h;
my $start_min;
my $correct;
my @skip_lines;
my $add_file;
my $penalty;
my @info_fields;
my @answers_fields;
my $beginner = 0;


for( @opt ){
	/-meta:(\S+)/ and do {
		$meta_file = $1;
	};
	/-beg/ and do {
		$beginner = 1;
	};
	/-ssv/ and do {
		$split = ' ';
	};
	/-nosep/ and do {
		$split = '';
	};
	/-d$/ and $debug = 1;
}

open my $countries, '<', $countries_file or die "$0: [$countries_file] ... : $!\n";
my @countries = grep m/./, <$countries>;
chomp @countries;

push @countries, ( 'England', 'GB', 'GBR', 'Great Britain', 'Scotland', 'Espana', 'España', 
		'Deutchland', 'Hong Kong', 'Italia', ' CZE', ' LTU', 'Polska', );

my $countries_re = join '|', @countries;

for( @FILES ){
	my $in;
	/^-$/ or open $in, '<', $_ or die "$0: [$_] ... : $!\n";
	my @data = map { [ map { s/[\r\n]//gr } split $split, $_, -1 ] }
		grep m/./, ( defined $in ? <$in> : <STDIN> );
	
	open my $meta, '<', $meta_file or die "$0: [$meta_file] ... : $!\n";
	my @meta = map { s/[\r\n]//gr }
		grep m/./, <$meta>;
	
	$event_day_re = quotemeta shift @meta;
	$start_h = shift @meta;
	$start_min = shift @meta;
	$correct = shift @meta;
	@skip_lines = grep /\d/, split ',', shift @meta;
	$add_file = shift @meta;
	$penalty = ( split ',', shift @meta )[ 0 + $beginner ];
	@info_fields = eval shift @meta;
	@answers_fields = eval shift @meta;
	
	my %lines_ok = map { $_, 1 } 1 .. @data;
	
	for my $skip_lines ( @skip_lines ){
		delete $lines_ok{ $skip_lines };
		}
	
	my @lines_ok = sort { $a <=> $b } keys %lines_ok;
	@data = @data[ map $_ - 1, @lines_ok ];
	
	open my $add, '<', $add_file or die "$0: [$add_file] ... : $!\n";
	my @add = map { [ map { s/[\r\n]//gr } split $split, $_, -1 ] }
		grep m/./, <$add>;
	
	for my $add ( @add ){
		my $found = 0;
		for my $record ( @data ){
			if( $add->[0] eq $record->[0] ){
				@{ $record } = @{ $add };
				$found ++;
				last;
				}
			}
		if( ! $found ){
			push @data, [ @{ $add } ];
			}
		}
	
	$correct =~ s/,//g;
	
	my $number_of_tasks = () = $correct =~ /\w/g;
	
	my %names_used;
	
	for my $record ( @data ){
		my( $Timestamp, $Score, $Name, $Email, $Level, $Time );
		my @answers;
		
		( $Timestamp, $Score, $Name, $Email, $Level, $Time ) = 
			@{ $record }[ @info_fields ];
		
		@answers = @{ $record }[ @answers_fields ];
		
		$names_used{ $Name } ++;
		
		my( $name, $YOB, $club, $country ) = split_info( $Name );
		
		### Time begin: 
		
		my $max_time = $number_of_tasks * $penalty * 2;
		
		my $old_Time = $Time;
		
		my $time_stamp;
		my $later_start = 0;
		
		if( $Timestamp !~ m{$event_day_re} ){
			$time_stamp = 3600;
			$later_start = 1;
			}
		else{
			my $h_m_s = ( split ' ', $Timestamp )[ 1 ];
			my( $h, $m, $s ) = map s/^0\B//r, split ':', $h_m_s;
			$time_stamp = ( $h * 3600 + $m * 60 + $s ) - ( $start_h * 3600 + $start_min * 60 );
			}
		
		$later_start = $time_stamp > 30 * 60;
		
		$later_start and $Timestamp = $Timestamp =~ s/\s+\S+\s*//r . ', Later';
		
		my $min = ( sort { $a <=> $b } $time_stamp, $max_time )[ 0 ];
		
		if( $Time =~ /\d/ and length $Time ){
			$Time = canonicalize_time( $Time );
			}
		else{
			$Time = $max_time;
			}
		
		$Time = ( sort { $a <=> $b } $min, $Time )[ 0 ];
		
		### Time end;
		
		$Level =~ s/ .+//; # Level:
		$Level =~ /./ or $Level = 'ELITE';
		
		my $number_of_OK = 0;
		
		for my $i ( 0 .. $number_of_tasks - 1 ){
			$correct =~ /\w/g;
			if( $answers[ $i ] eq $& ){
				$number_of_OK ++;
				}
			}
		
		$correct =~ /\w/g; # reset pos();
		
		my $this_penalty = $penalty * ( $number_of_tasks - $number_of_OK );
		
		my $time_sum = $Time + $this_penalty;
		
		if( $names_used{ $Name } > 1 ){
			$Level = "RUN#" . $names_used{ $Name } . "(" . ( substr $Level, 0, 1 ) . ")";
			$time_sum = 9999;
			}
		
		@{ $record } = ( $Level, $name, $YOB, $club, $country,  
			$Timestamp, "[$old_Time]", $Time, $number_of_OK, $this_penalty, $time_sum, @answers );
			
		}
	
	my $header = [ 'Place', 'Level', 'Name', 'YOB', 'Club', 'Country', 'Timestamp', '[Time submit]', 'Time', 
		'#OK', 'pen.', 'TIME_SUM', ( split //, $correct ) ];
	
	@data = sort { $a->[10] <=> $b->[10] } @data;
	
	
	my $place = 1;
	my $static_place = $place;
	my $last_sum = 0;
	
	my $eval_level = $beginner == 1 ? 'BEGINNER' : 'ELITE';
	
	for my $record ( @data ){
		if( $record->[ 0 ] ne $eval_level ){
			unshift @{ $record }, '';
			next;
			}
		if( $record->[10] != $last_sum ){
			$static_place = $place;
			}
		$last_sum = $record->[10];
		unshift @{ $record }, $static_place;
		$place ++;
		}
	
	print map "$_\n", join $join, @{ $_ } for $header, @data;
	
	}

sub split_info {
	my $info = shift;
	
	$info =~ s/\[([^,]*)\]/$1/g;
	$info =~ s/\s*\*$//;
	$info =~ s/\s*$//;
	
	my( $name, $YOB, $club, $country );
	my $club_country;
	
	if( $info =~ /,?\s*(\d{4}[^,\s]*)[, ]+/ ){
		$YOB = $1;
		$name = $`;
		$club_country = $';
		}
	else{
		( $name, $club_country ) = split ',', $info, 2;
		}
	
	( $club, $country ) = grep /./, split ',', $club_country, 2;
	if( $club =~ /\s*($countries_re)$/i ){
		$club = $`;
		$country = $1;
		}
	
	if( $name =~ /\s*($countries_re)$/i ){
		$name = $`;
		$country = $1;
		}
	
	( $name, $YOB, $club, $country ) = map { s/^\s*\-//; s/-\s*$//; s/^\s+//; s/\s+$//; $_ } 
		( $name, $YOB, $club, $country );
	
	$name = ucfirst $name;
	
	return( $name, $YOB, $club, $country );
	}


sub canonicalize_time {
	my $time = shift;
	
	$time =~ s/\*\s*$//;
	
	if( $time =~ /(\d+)\s*-\s*(\d+)/ ){
		$time = ( $1 + $2 ) / 2;
		}
	
	$time =~ s/(?<=.);(?=.)/:/;
	$time =~ s/ ?(?:m[a-z]*)\s*/:/i;
	$time =~ s/:$//;
	$time =~ s/''/s/;
	$time =~ s/"/s/;
	
	if( $time =~ /:/ ){
		$time = $` * 60 + $';
		}
	elsif( $time =~ s/\s*s\w*\.?$// ){
		;
		}
	elsif( $time =~ /\d{3}/ ){
		$time *= 1;
		}
	else{
		$time *= 60;
		}
	
	return $time;
	}
