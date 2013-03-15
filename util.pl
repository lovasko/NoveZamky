% print_list(+List)
% recursively prints elements of list
print_list([]) :- print('.').
print_list([H|T]) :-
	print(H),
	(T = [] ; print(', ')),
	print_list(T), !.

% print_sudoku1(+ValuesList)
% BUG prints the sudoku rotated counter-clockwise 90 degrees
print_sudoku1([], _).
print_sudoku1([[_, Y, Value] | Fields], Width) :-
	print(Value), print(' '),
	(Y = Width, format('~n', _) ; true),
	print_sudoku1(Fields, Width), !.

reverse_xy([], []).
reverse_xy([[X, Y, Value]|T], [[Y, X, Value] | U]) :- reverse_xy(T, U).

	
% print_sudoku(+Sudoku)
% preprocessing for print_sudoku1
print_sudoku(Sudoku) :-
	Sudoku = sudoku(M, N, Fields),
	reverse_xy(Fields, Reversed),
	sort(Reversed, Sorted),
	Width is M*N - 1,
	print_sudoku1(Sorted, Width).

% subtract - copied from swi-pl 'listing(subtract)'
subtract([], _, []) :- !.
subtract([A|C], B, D) :-
	memberchk(A, B), !,
	subtract(C, B, D).
subtract([A|B], C, [A|D]) :-
	subtract(B, C, D).

