:- include('util.pl').
:- include('io.pl').
:- include('get.pl').
:- initialization(main).

main :-
	getopt(File),
	open_file(File),
	parse_sudoku(Sudoku),
	correct(Sudoku, [0, 0, _], C), print(C).
	