% TODO - save error to variable and make recovery procedure with pattern matching
open_file(File) :-
	catch(open(File, read, Stream), _, format('Error opening file %s', [File])),
	set_input(Stream).

% TODO - put numbers inside f() structure alongside with X and Y coordinates
parse_numbers(Old, New) :-
	catch(read_integer(Number), _, Number = end_of_file),
	(Number = end_of_file,
		Old = New
	)
	;
	(
		append(Old, [Number], New),
		parse_numbers(New, _)
	).


parse_dimension(M, N) :-
	read_integer(M),
	read_integer(N).

parse_sudoku(Sudoku) :-
	parse_dimension(M, N),
	parse_numbers([], Numbers),
	Sudoku = sudoku(M, N, Numbers).