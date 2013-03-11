% TODO - save error to variable and make recovery procedure with pattern matching
open_file(File) :-
	catch(open(File, read, Stream), _, format('Error opening file %s', [File])),
	set_input(Stream).

parse_numbers(M, N, Position, List, Result) :-
	read(Number),
	(Number = end_of_file, Result = List ;
		X is Position mod (M * N),
		Y is Position div (M * N),	
		NewList = [ [X, Y, Number] | List ], 
		NextPosition is Position + 1,
		parse_numbers(M, N, NextPosition, NewList, Result)).


parse_dimension(M, N) :-
	read(M),
	read(N).

parse_sudoku(Sudoku) :-
	parse_dimension(M, N),
	parse_numbers(M, N, 0, [], Numbers),
	Sudoku = sudoku(M, N, Numbers).