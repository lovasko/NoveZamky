is_neighbour([X1, Y1, _], [X2, Y2, _]) :-
	abs(X1 - X2) =< 1,
	abs(Y1 - Y2) =< 1.

% neighbours for field
nff([], _, []).
nff([H|T], Field, [H|Ns]) :- is_neighbour(H, Field), nff(T, Field, Ns).
nff([H|T], Field, Ns) :- nff(T, Field, Ns).

% count neighbours
count_ns(Fields, Field, Tuple) :-
	nff(Fields, Field, Ns),
	length(Ns, Count),
	Tuple = Count-Field.

listify1([], _, []).
listify1(Fields, Seen, [Field|ListedFields]) :-
	maplist(count_ns(Seen), Fields, Tuples),
	keysort(Tuples, SortedTuples),
	reverse(SortedTuples, ReversedSortedTuples),
	[Count-Field|_] = ReversedSortedTuples,
	delete(Fields, Field, NewFields),
	listify1(NewFields, [Field|Seen], ListedFields).

already_done([], []).
already_done([H|T], Initial) :-
	H = [_, _, 0],
	already_done(T, Initial).
already_done([H|T], [H|Initial]) :- already_done(T, Initial).

listify(Sudoku, List) :-
	Sudoku = sudoku(_, _, Fields),
	already_done(Fields, Initial),
	subtract(Fields, Initial, FieldsZero),
	listify1(FieldsZero, Initial, List).