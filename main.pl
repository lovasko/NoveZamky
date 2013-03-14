:- include('util.pl').
:- include('io.pl').
:- include('get_set.pl').
:- include('listify.pl').
:- include('solve.pl').
:- initialization(main(S)).

main(SolvedSudoku) :-
	getopt(File),
	open_file(File),
	parse_sudoku(Sudoku),
	listify(Sudoku, List),
	solve(Sudoku, List, SolvedSudoku),
	print_sudoku(SolvedSudoku).
	