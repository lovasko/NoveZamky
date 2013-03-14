% getopt(-File)
% tries to read commandline arguments
% if none provided, asks user to specify file containing sudoku data
% if provided, first parameter is used
getopt(File) :-
	argument_list(ArgumentList),
	ArgumentList = [], print('Write file name containig sudoku: '),	read_token(File)
	;
	argument_value(1, File).

% open_file(+File)
% opens File and uses it as stdin
% TODO - save error to variable and make recovery procedure with pattern matching
open_file(File) :-
	catch(open(File, read, Stream), _, format('Error opening file %s', [File])),
	set_input(Stream).

% parse_numbers(+M, +N, ?Position, +List, -Result)
% reads stdin for terms
% for each term based on position computes its XY coordinates
% uses accumulator technique
parse_numbers(M, N, Position, List, Result) :-
	read(Number),
	(Number = end_of_file, Result = List ;
		X is Position mod (M * N),
		Y is Position div (M * N),
		NewList = [ [X, Y, Number] | List ], 
		NextPosition is Position + 1,
		parse_numbers(M, N, NextPosition, NewList, Result)).

% parse_dimension(-M, -N)
% reads two integers from stdin and returns both
parse_dimension(M, N) :-
	read(M),
	read(N).

% parse_sudoku(-Sudoku)
% utilizes previous procedures
% sudoku is stored in sudoku/3 predicate
% first two are dimensions of the sudoku
% third argument is list of lists, called fields
% a field is a list of length 3
%    first element is X coordinate
%    second element is Y coordinate
%    third element is value of the field
parse_sudoku(Sudoku) :-
	parse_dimension(M, N),
	parse_numbers(M, N, 0, [], Numbers),
	Sudoku = sudoku(M, N, Numbers).