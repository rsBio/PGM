#!/usr/bin/perl

use warnings;
use strict;

	my $debug = 0;
	
	my @FILES;
	my @opt;
	
	for( @ARGV ){
		/^-\S/ ? ( push @opt, $_ ) : ( push @FILES, $_ );
		}
	
	my $string;
	my $whose_move;
	my $empty = '.';
	my $white_square = "▒";
	my $print_possible_moves = 0;
	my $print_board_only = 0;
	my $show_possible_moves = 0;
	my $print_number_of_possible_moves = 0;
	my $print_axes = 0;
	
	for( @opt ){
		/-W/i and do {
			$whose_move = 'W';
		};
		/-B/i and do {
			$whose_move = 'B';
		};
		/-nmoves/i and do {
			$print_number_of_possible_moves = 1;
		};
		/-p(rint)?moves/i and do {
			$print_possible_moves = 1;
		};
		/-p(rint)?board/i and do {
			$print_board_only = 1;
		};
		/-showmoves/i and do {
			$show_possible_moves = 1;
		};
		/-p(rint)?axes/i and do {
			$print_axes = 1;
		};
		/-d$/ and $debug = 1;
		}
	
	my @Board;
	
	$Board[ $_ ] = [ ( $empty ) x 8 ] for 0 .. 8 - 1;
	
	if( @FILES ){
		open my $in, '<', "$FILES[ 0 ]" or die "$0: Can't open file $_!\n";
		$string = <$in> =~ s/\s//gr;
		}
	
	init_board( \@Board, \$whose_move, $string );
	
	if( $print_board_only ){
		print_board( \@Board, $whose_move );
		exit;
		}
	
	my $game_over = 0;
	
	while( ! $game_over ){
		my @possible_moves = get_moves( \@Board, $whose_move );
		
		if( ! @possible_moves ){
			print '' . ( $whose_move eq 'B' ? 'White' : 'Black' ), " have won!\n";
			last;
			}
		
		print '' . ( $whose_move eq 'W' ? 'White' : 'Black' ), " is to move.\n";
		
		print_board( \@Board, $whose_move );
		
		$print_number_of_possible_moves and print "Number of possible moves: " . @possible_moves . "\n";
		
		if( $print_possible_moves ){
			for( @possible_moves ){
				print map "$_\n", 
					join '-', numbers_to_letters( reverse @{ $_->[ 1 ] } );
				}
			}
		
		$show_possible_moves and show_possible_moves( \@Board, \@possible_moves );
		
		while( 1 ){
			my $move = <STDIN>;
			chomp $move;
			my( $ref_corresponding_move ) = grep { 
				$move eq join '-', numbers_to_letters( reverse @{ $_->[ 1 ] } ) 
				} @possible_moves;
			if( $ref_corresponding_move  ){
				
				make_move( \@Board, $ref_corresponding_move );
				$whose_move =~ y/WB/BW/;
				
				last;
				}
			else{
				print "This move is invalid. Try again.\n";
				next;
				}
			}
		
	##	$game_over = 1;
		}
	
	print_board( \@Board, $whose_move );
	
	sub numbers_to_letters {
		map s/./ ( 'a' .. 'z' )[ $& - 1 ] /re, 
			map { join '', reverse map $_ + 1, split } @_;
		}
	
	sub make_move {
		my $ref_Board = shift @_;
		my $ref_corresponding_move = shift @_;
		
		my( $i, $j ) = split ' ', $ref_corresponding_move->[ 1 ][ 0 ];
		$ref_Board->[ $i ][ $j ] = $ref_corresponding_move->[ 0 ] ? $whose_move : lc $whose_move;
		
		( $i, $j ) = split ' ', ( reverse @{ $ref_corresponding_move->[ 1 ] } )[ 0 ];
		$ref_Board->[ $i ][ $j ] = $empty;
		
		for my $captured ( @{ $ref_corresponding_move->[ 3 ] } ){
			my( $i, $j ) = split ' ', $captured;
			$ref_Board->[ $i ][ $j ] = $empty;
			}	
		}
	
	sub show_possible_moves {
		my $ref_Board = shift @_;
		my $ref_possible_moves = shift @_;
		
		my $k = 0;
		for my $move ( @{ $ref_possible_moves } ){
			$k ++;
			
			print "Move $k:\n";
			$debug and print "$move->[ 0 ] <<@{ $move->[ 1 ] }>> <<@{ $move->[ 2 ] }>> <<@{ $move->[ 3 ] }>>\n";
			
		#	print_board( $ref_Board, $whose_move );
			
			my @jumps = @{ $move->[ 1 ] };
			
			my @new_Board;
			push @new_Board, [ @{ $_ } ] for @{ $ref_Board };
			
			for my $jump ( @{ $move->[ 1 ] } ){
				my( $i, $j ) = split ' ', $jump;
				$new_Board[ $i ][ $j ] = '+';
				}
			
			my( $i, $j ) = split ' ', $move->[ 1 ][ 0 ];
			$new_Board[ $i ][ $j ] = '*';
			
			( $i, $j ) = split ' ', ( reverse @{ $move->[ 1 ] } )[ 0 ];
			$new_Board[ $i ][ $j ] = '@';
			
			for my $captured ( @{ $move->[ 3 ] } ){
				my( $i, $j ) = split ' ', $captured;
				$new_Board[ $i ][ $j ] = '?';
				}
			
			print_board( \@new_Board, $whose_move );
			}	
		}
		
	sub init_board {
		my $ref_Board = shift @_;
		my $ref_whose_move = shift @_;
		
		my $default_string = join '', qw( W a1 c1 e1 g1 b2 d2 f2 h2 a3 c3 e3 g3 + b6 d6 f6 h6 a7 c7 e7 g7 b8 d8 f8 h8 );
		
		my $this_board_string = @_ ? shift @_ : $default_string;
		
		my $whose_move = substr $this_board_string, 0 , 1, '';
		${ $ref_whose_move } //= $whose_move;
		
		$debug and print ${ $ref_whose_move } . "\n";
		$debug and print $this_board_string . "\n";
		
		my( $white, $black ) = split '\+', $this_board_string;
		
		my $i = 0;
		
		for my $color ( $white, $black ){
			my $piece_color = $i ++ % 2 ? 'b' : 'w';
			
			for my $piece ( $color =~ /../g ){
				my( $row, $col ) = reverse split //, $piece;
				
				$ref_Board->[ $row - 1 ][ index( ( join '', 'a' .. 'z' ), lc $col ) ] = 
					$col eq lc $col ? $piece_color : uc $piece_color;
				}
			}
		}
	
	sub get_moves {
		my $ref_Board = shift @_;
		my $whose_move = shift @_;
		
		$debug and print " BEGIN: if any piece can capture?\n";
		
		my $if_any_piece_can_capture = 0;
		
		IF_ANY_PIECE_CAN_CAPTURE:
		for my $i ( 0 .. 8 - 1 ){  # BEGIN if any piece can capture?
			for my $j ( 0 .. 8 - 1 ){
				next if $whose_move ne uc $ref_Board->[ $i ][ $j ];
				
				$debug and print "  piece on [$i,$j]:\n";
				
				my $man_king = 0;
				
				if( $ref_Board->[ $i ][ $j ] eq uc $ref_Board->[ $i ][ $j ] ){
					$man_king = 1;
					}
				
				$debug and print "  man_king: $man_king\n";
				
				my @directions = get_capture_directions( $man_king, $whose_move );
				
				my $start = [ $man_king, [ "$i $j" ], [ @directions ] ];
				
				my @try;
				
				push @try, $start;
				
				while( @try ){
					my $try = shift @try;
					my $man_king = $try->[ 0 ];
					my( $i, $j ) = split ' ', $try->[ 1 ][ 0 ];
					my @directions = @{ $try->[ 2 ] };
					
					for my $direction ( @directions ){
						my( $add_row, $add_col ) = split ' ', $direction;
						my $possible = 1;
						my $jumped = 0;
						my $distance = 0;
						while( $possible ){
							$distance ++;
							last if $distance > 2 and $man_king == 0;
							my $ii = $i + $add_row * $distance;
							my $jj = $j + $add_col * $distance;
							last if out_of_bounds( $ii, $jj );
							$debug and print "   to: ", $ii, ", ", $jj, "?\n";
							
							if( $ref_Board->[ $ii ][ $jj ] eq '.' ){
								if( $jumped == 1 ){
									$if_any_piece_can_capture = 1;
									last IF_ANY_PIECE_CAN_CAPTURE;
									}
								}
							elsif( uc $ref_Board->[ $ii ][ $jj ] eq $whose_move ){
								$possible = 0;
								}
							else{
								$jumped ++;
								if( $jumped > 1 ){
									$possible = 0;
									}
								}
							}
						}
					
					}
				
				}
			}  # END: if any piece can capture?
		
		$debug and print " END: if any piece can capture?\n";
		$debug and print " if_can_capture: $if_any_piece_can_capture\n";
		
		my @moves;
		
		if( $if_any_piece_can_capture == 1 ){
			
			$debug and print " BEGIN: capture\n";
			
			for my $i ( 0 .. 8 - 1 ){
				for my $j ( 0 .. 8 - 1 ){
					next if $whose_move ne uc $ref_Board->[ $i ][ $j ];
					
					$debug and print "  piece on [$i,$j]:\n";
					
					my $man_king = 0;
					
					if( $ref_Board->[ $i ][ $j ] eq uc $ref_Board->[ $i ][ $j ] ){
						$man_king = 1;
						}
					
					$debug and print "  man_king: $man_king\n";
					
					my @directions = get_capture_directions( $man_king, $whose_move );
					
					my @squares_with_directions = ( [ $man_king, [ "$i $j" ], [ @directions ], [] ] );
					
					my $start = [ @squares_with_directions ];
					
					my @try;
					
					push @try, $start;
					
					while( @try ){
						my $try = shift @try;
						my @squares_with_directions = @{ $try };
						
						my $if_this_piece_can_capture_further = 0;
						
						IF_THIS_PIECE_CAN_CAPTURE_FURTHER:
						for my $square_with_directions ( @squares_with_directions ){
							my $man_king = $square_with_directions->[ 0 ];
							my( $i, $j ) = split ' ', $square_with_directions->[ 1 ][ 0 ];
							my @directions = @{ $square_with_directions->[ 2 ] };
							my @captured = @{ $square_with_directions->[ 3 ] };
							
							for my $direction ( @directions ){
								my( $add_row, $add_col ) = split ' ', $direction;
								my $possible = 1;
								my $jumped = 0;
								my $distance = 0;
								while( $possible ){
									$distance ++;
									last if $distance > 2 and $man_king == 0;
									my $ii = $i + $add_row * $distance;
									my $jj = $j + $add_col * $distance;
									last if out_of_bounds( $ii, $jj );
									
									if( $ref_Board->[ $ii ][ $jj ] eq '.' or 
										grep { "$ii $jj" eq $_ } @captured
										){
										if( $jumped == 1 ){
											$if_this_piece_can_capture_further = 1;
											last IF_THIS_PIECE_CAN_CAPTURE_FURTHER;
											}
										}
									elsif( uc $ref_Board->[ $ii ][ $jj ] eq $whose_move ){
										$possible = 0;
										}
									else{
										$jumped ++;
										if( $jumped > 1 ){
											$possible = 0;
											}
										}
									}
								}
							}
						
						if( $if_this_piece_can_capture_further == 1 ){
							
							for my $square_with_directions ( @squares_with_directions ){
								my $man_king = $square_with_directions->[ 0 ];
								my( $i, $j ) = split ' ', $square_with_directions->[ 1 ][ 0 ];
								my @directions = @{ $square_with_directions->[ 2 ] };
								my @captured = @{ $square_with_directions->[ 3 ] };
								
								for my $direction ( @directions ){
									my( $add_row, $add_col ) = split ' ', $direction;
									my $possible = 1;
									my $jumped = 0;
									my $distance = 0;
									my @further_directions = (
										( join ' ', -$add_row, $add_col ),
										( join ' ', $add_row, -$add_col ),
										);
									my $captured;
									my @further_search;
									
									while( $possible ){
										$distance ++;
										last if $distance > 2 and $man_king == 0;
										my $ii = $i + $add_row * $distance;
										my $jj = $j + $add_col * $distance;
										last if out_of_bounds( $ii, $jj );
										$debug and print "   to: ", $ii, ", ", $jj, "?\n";
										
										if( $ref_Board->[ $ii ][ $jj ] eq '.' or 
											grep { "$ii $jj" eq $_ } @captured 
											){
											if( $jumped == 1 ){
												my $man_king_there = $man_king;
												if( $whose_move eq 'W' and $ii == 8 - 1 or $whose_move eq 'B' and $ii == 0 ){
													$man_king_there = 1;
													}
												if( $ref_Board->[ $ii - $add_row ][ $jj - $add_col ] ne '.' ){
													push @further_directions, join ' ', $add_row, $add_col;
													$captured = join ' ', $ii - $add_row, $jj - $add_col;
													}
												push @further_search, [ 
													$man_king_there, 
													[ "$ii $jj", @{ $square_with_directions->[ 1 ] } ], 
													[ @further_directions ], 
													[ $captured, @{ $square_with_directions->[ 3 ] } ] 
													];
												}
											}
										elsif( uc $ref_Board->[ $ii ][ $jj ] eq $whose_move ){
											$possible = 0;
											}
										else{
											$jumped ++;
											if( $jumped > 1 ){
												$possible = 0;
												}
											}
										}
									
									push @try, [ @further_search ];
									}
								}
							}
						else{
							push @moves, grep { 1 < @{ $_->[ 1 ] } } @squares_with_directions;
							}
						
						}
					
					}
				}
			
			$debug and print " END: capture\n";
			}
		else{
			$debug and print " BEGIN: move without capture\n";
			
			for my $i ( 0 .. 8 - 1 ){
				for my $j ( 0 .. 8 - 1 ){
					next if $whose_move ne uc $ref_Board->[ $i ][ $j ];
					
					$debug and print "  piece on [$i,$j]:\n";
					
					my $man_king = 0;
					
					if( $ref_Board->[ $i ][ $j ] eq uc $ref_Board->[ $i ][ $j ] ){
						$man_king = 1;
						}
					
					$debug and print "  man_king: $man_king\n";
					
					my @directions = get_move_directions( $man_king, $whose_move );
					
					my $start = [ $man_king, [ "$i $j" ], [ @directions ] ];
					
					my @try;
					
					push @try, $start;
					
					while( @try ){
						my $try = shift @try;
						my $man_king = $try->[ 0 ];
						my( $i, $j ) = split ' ', $try->[ 1 ][ 0 ];
						my @directions = @{ $try->[ 2 ] };
						
						for my $direction ( @directions ){
							my( $add_row, $add_col ) = split ' ', $direction;
							my $possible = 1;
							my $jumped = 0;
							my $distance = 0;
							while( $possible ){
								$distance ++;
								last if $distance > 1 and $man_king == 0;
								my $ii = $i + $add_row * $distance;
								my $jj = $j + $add_col * $distance;
								last if out_of_bounds( $ii, $jj );
								$debug and print "   to: ", $ii, ", ", $jj, "?\n";
								
								if( $ref_Board->[ $ii ][ $jj ] eq '.' ){
									if( $jumped == 0 ){
										my $man_king_there = $man_king;
										if( $whose_move eq 'W' and $ii == 8 - 1 or $whose_move eq 'B' and $ii == 0 ){
											$man_king_there = 1;
											}
										push @moves, [ $man_king_there, [ "$ii $jj", @{ $try->[ 1 ] } ], [], [] ];
										}
									else{
										last;
										}
									}
								elsif( uc $ref_Board->[ $ii ][ $jj ] eq $whose_move ){
									$possible = 0;
									}
								else{
									$jumped ++;
									if( $jumped > 1 ){
										$possible = 0;
										}
									}
								}
							}
						
						}
					
					}
				}
			
			$debug and print " END: move without capture\n";
			}
		
		@moves;
		}
	
	sub get_capture_directions {
		( '1 -1', '1 1', '-1 -1', '-1 1' );
		}
	
	sub get_move_directions {
		my( $man_king, $whose_move ) = @_;
		my @directions;
		
		if( $man_king == 1 ){
			@directions = ( '1 -1', '1 1', '-1 -1', '-1 1' );
			}
		else{
			if( $whose_move eq 'W' ){
				@directions = ( '1 -1', '1 1' );
				}
			else{
				@directions = ( '-1 -1', '-1 1' );
				}
			}
		
		@directions;
		}
	
	sub out_of_bounds {
		grep { $_ < 0 || $_ > 8 - 1 } @_;
		}
	
	sub print_board {
		my $ref_Board = shift @_;
		my $whose_move = shift @_;
		
		for my $i ( reverse 0 .. 8 - 1 ){
			$print_axes and print $i + 1 . ' ';
			for my $j ( 0 .. 8 - 1 ){
				print 1 == ( $i + $j ) % 2 ? $white_square : $ref_Board->[ $i ][ $j ];
				}
			print "\n";
			}
		
		$print_axes and print '  ' . ( join '', 'a' .. 'h' ) . "\n";
		
		print $whose_move . "\n";
		}
	