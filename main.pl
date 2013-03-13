:- include('util.pl').
:- include('io.pl').
:- include('get.pl').
:- initialization(main).

main(List) :-
	getopt(File),
	open_file(File),
	parse_sudoku(Sudoku),
	listify(Sudoku, List).
	