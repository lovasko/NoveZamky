:- include('util.pl').
:- include('io.pl').
:- initialization(main).

main :-
	getopt(File),
	open_file(File),
	parse_sudoku(Sudoku),
	sudoku(M, N, Numbers) = Sudoku,
	print(M), print(N), print_list(Numbers).
	