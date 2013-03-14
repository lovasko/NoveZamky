% print_list(+List)
% recursively prints elements of list
print_list([]) :- print('.').
print_list([H|T]) :-
	print(H),
	(T = [] ; print(', ')),
	print_list(T), !.

% print_sudoku1(+ValuesList)
% TODO add width parameter, which should be M*N
% BUG prints the sudoku rotated counter-clockwise 90 degrees
print_sudoku1([]).
print_sudoku1([H|Values]) :-
	H = [X, Y, V],
	print(V), print(' '),
	(Y = 3, format('~n', _) ; true),
	print_sudoku1(Values).

% print_sudoku(+Sudoku)
% preprocessing for print_sudoku1
print_sudoku(Sudoku) :-
	Sudoku = sudoku(_, _, Values),
	sort(Values, Sorted),
	print_sudoku1(Sorted).

% subtract - copied from swi-pl 'listing(subtract)'
subtract([], _, []) :- !.
subtract([A|C], B, D) :-
	memberchk(A, B), !,
	subtract(C, B, D).
subtract([A|B], C, [A|D]) :-
	subtract(B, C, D).

