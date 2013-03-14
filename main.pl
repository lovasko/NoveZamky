:- include('util.pl').
:- include('io.pl').
:- include('get.pl').
:- initialization(main(Ss)).

main(SolvedSudoku) :-
	getopt(File),
	open_file(File),
	parse_sudoku(Sudoku),
	listify(Sudoku, List),
	solve(Sudoku, List, SolvedSudoku),
	print_sudoku(SolvedSudoku).
	