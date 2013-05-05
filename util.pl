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
	
% reverse_xy(+Fields, -ReversedXYFields)
% Values stay intact, only X and Y swap for sorting purposes
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
	
possible_solution(Sudoku) :-
	format('Possible solution: ~n', _),
	print_sudoku(Sudoku).


% subtract - copied from swi-pl 'listing(subtract)'
subtract([], _, []) :- !.
subtract([A|C], B, D) :-
	memberchk(A, B), !,
	subtract(C, B, D).
subtract([A|B], C, [A|D]) :-
	subtract(B, C, D).

% gtz(+List, -List)
% only elements GreaterThanZero pass this filter
gtz([], []).
gtz([H|In], [H|Out]) :- H > 0, gtz(In, Out).
gtz([_|In], Out) :- gtz(In, Out).

% compress_consecutive(+List, -UniqueConsecutive)
% ouputs only those elements, that are unique
% requires duplicates to be listed together
compress_consecutive([], []).
compress_consecutive([H|T], U) :- U = [H|_], compress_consecutive(T, U).
compress_consecutive([H|T], [H|U]) :- compress_consecutive(T, U).

