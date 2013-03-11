:- include('util.pl').
:- include('io.pl').
:- include('get.pl').
:- initialization(main).

main :-
	getopt(File),
	open_file(File),
	parse_sudoku(Sudoku),
	sudoku(M, N, Numbers) = Sudoku,
	get_row_values(Sudoku, 1, Values), print_list(Values).
	