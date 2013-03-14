list_empty([]).

print_list([]) :- print('.').
print_list([H|T]) :-
	print(H),
	print_list(T).

% add width parameter, which should be M*N
print_sudoku1([]).
print_sudoku1([H|Values]) :-
	H = [X, Y, V],
	print(V), print(' '),
	(Y = 3, format('~n', _) ; true),
	print_sudoku1(Values).

print_sudoku(Sudoku) :-
	Sudoku = sudoku(_, _, Values),
	sort(Values, Sorted),
	print_sudoku1(Sorted).

subtract([], _, []) :- !.
subtract([A|C], B, D) :-
	memberchk(A, B), !,
	subtract(C, B, D).
subtract([A|B], C, [A|D]) :-
	subtract(B, C, D).

