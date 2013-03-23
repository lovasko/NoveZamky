:- include('util.pl').
:- include('io.pl').
:- include('get_set.pl').
:- include('listify.pl').
:- include('solve.pl').
:- include('adhoc.pl').
:- initialization(main_false).

:- dynamic(start_time/1).

% main(-SolvedSudoku)
main(SolvedSudoku) :-
	getopt(File, Method),
	valid_method(Method),
	open_file(File),
	parse_sudoku(Sudoku),
	format('Solving sudoku:~n', _),
	print_sudoku(Sudoku),
	user_time(Start),
	asserta(start_time(Start)),
	listify(Method, Sudoku, List), !,
	solve(Sudoku, List, SolvedSudoku, 'nodebug'),
	format('~nPossible solution: ~n', _),
	print_sudoku(SolvedSudoku).

main_false :-
	main(_),
	false.
main_false :- finish.

% dynamic solving
adhoc_main(SolvedSudoku) :-
	getopt(File, _),
	open_file(File),
	parse_sudoku(Sudoku),
	format('Solving sudoku:~n', _),
	print_sudoku(Sudoku),
	user_time(Start),
	asserta(start_time(Start)), !,
	adhoc(Sudoku, SolvedSudoku),
	format('~nPossible solution: ~n', _),
	print_sudoku(SolvedSudoku).

adhoc_main_false :-
	adhoc_main(_),
	false.
adhoc_main_false :- finish.
	
% finish
% prints time difference
finish :-
	start_time(Start), 
	user_time(End), 
	Duration is End-Start,
	format('Time: %dms~n', [Duration]).