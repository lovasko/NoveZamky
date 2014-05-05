:- include('util.pl').
:- include('io.pl').
:- include('get_set.pl').
:- include('listify.pl').
:- include('solve.pl').
:- include('adhoc.pl').
:- initialization(main1).
:- dynamic(start_time/1).


main :-
	getopt(File, Method),
	valid_method(Method),
	open_file(File),
	parse_sudoku(Sudoku),
	format('Solving sudoku:~n', _),
	print_sudoku(Sudoku),
	user_time(Start),
	asserta(start_time(Start)),
	!,
	method_switch(Sudoku, Method).

main1 :-
	main,
	false.	
main1 :-
	start_time(Start),
	user_time(End),
	Duration is End - Start,
	format('Time: %dms~n', [Duration]).

method_switch(Sudoku, adhoc) :-
	adhoc(Sudoku, SolvedSudoku),
	possible_solution(SolvedSudoku).

method_switch(Sudoku, Method) :-
	listify(Method, Sudoku, List), !,
	solve(Sudoku, List, SolvedSudoku, 'nodebug'),
	possible_solution(SolvedSudoku).