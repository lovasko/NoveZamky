:- include('util.pl').
:- include('io.pl').
:- include('get_set.pl').
:- include('listify.pl').
:- include('solve.pl').
:- initialization(main_false).

% main(-SolvedSudoku)
main(SolvedSudoku) :-
	getopt(File),
	open_file(File),
	parse_sudoku(Sudoku),
	format('Solving sudoku:~n', _),
	print_sudoku(Sudoku),
	listify(Sudoku, List), !,
	solve(Sudoku, List, SolvedSudoku, 'nodebug'),
	format('~nPossible solution: ~n', _),
	print_sudoku(SolvedSudoku).

main_false :- main(_), false.
main_false :- format('Done.~n', _).