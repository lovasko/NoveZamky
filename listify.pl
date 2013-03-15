% is_neighbour(+Field1, +Field2)
% returns true, if Field1 is neighbour of Field2 (or vice versa)
% otherwise false
is_neighbour([X1, Y1, _], [X2, Y2, _]) :-
	abs(X1 - X2) =< 1,
	abs(Y1 - Y2) =< 1.

% nff(+AlreadyDoneFields, +Field, -Neighbours)
% neighbours for Field from AlreadyDoneFields
nff([], _, []).
nff([H|T], Field, [H|Ns]) :- is_neighbour(H, Field), nff(T, Field, Ns).
nff([H|T], Field, Ns)     :- nff(T, Field, Ns).

% count_ns(+AlreadyDoneFields, +Field, +Tuple)
% count neighbours - Tuple's format is Count-Field
% used as high-order procedure's argument (maplist in listify1)
count_ns(Fields, Field, Count-Field) :-
	nff(Fields, Field, Ns),
	length(Ns, Count).

% already_done(+AllFields, -ZeroFields)
% filters Fields with 0 value (so called not-yet-set)
already_done([], []).
already_done([[_, _, 0]|T], Initial) :- already_done(T, Initial).
already_done([H|T],[H|Initial]) :- already_done(T, Initial).

% listify(+Sudoku, -List)
% returns heuristically computed list of not-yet-set fields
% heuristics: number of already set neighbours (in time)
listify(sudoku(_, _, Fields), List) :-
	already_done(Fields, Initial), !,
	subtract(Fields, Initial, FieldsZero),
	listify1(FieldsZero, Initial, List).

% listify1(+FieldsList, +SeenFieldsList, -HeuristicList)
% computional helper for listify/2
% % compute Count of neighbours for each field in Fields, 
% % % depending on current Seen
% % sort by key (the Count)
% % take first and add it to HeuristicList
listify1([], _, []).
listify1(Fields, Seen, [Field|ListedFields]) :-
	maplist(count_ns(Seen), Fields, Tuples),
	keysort(Tuples, SortedTuples),
	reverse(SortedTuples, ReversedSortedTuples),
	[Count-Field|_] = ReversedSortedTuples,
	delete(Fields, Field, NewFields),
	listify1(NewFields, [Field|Seen], ListedFields), !.