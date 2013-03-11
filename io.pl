% TODO - save error to variable and make recovery procedure with pattern matching
open_file(File) :-
	catch(open(File, read, Stream), _, format('Error opening file %s', [File])),
	set_input(Stream).

% TODO - put numbers inside f() structure alongside with X and Y coordinates
parse_numbers(List, Result) :-
	read(Number),
	(Number = end_of_file, Result = List ;	
		New = [Number | List], parse_numbers(New, Result)).


parse_dimension(M, N) :-
	read(M),
	read(N).

parse_sudoku(Sudoku) :-
	parse_dimension(M, N),
	parse_numbers([], Numbers),
	Sudoku = sudoku(M, N, Numbers).