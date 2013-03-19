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

% count_ns(+AlreadyDoneFields, +Field, -Tuple)
% count neighbours - Tuple's format is Count-Field
% used as high-order procedure's argument (maplist in listify1)
count_ns(Fields, Field, Count-Field) :-
	nff(Fields, Field, Ns),
	length(Ns, Count).

% count_relatives(+AlreadyDoneFields, +Field, -Tuple)
% relatives to Field are such fields from AlreadyDoneFields, that share the
%    same row, column, or area.
count_relatives(sudoku(M, N, _), Fields, [X, Y, Value], Count-[X, Y, Value]) :-
	filter_same_row(Y, Fields, Row),
	filter_same_column(X, Fields, Column),
	filter_same_area(X, Y, M, N, Fields, Area),
	append(Row, Column, Tmp),
	append(Tmp, Area, Relatives),
	sort(Relatives, Sorted),
	compress_consecutive(Sorted, Unique),
	length(Unique, Count).

% already_done(+AllFields, -ZeroFields)
% filters Fields with 0 value (so called not-yet-set)
already_done([], []).
already_done([[_, _, 0]|T], Initial) :- already_done(T, Initial).
already_done([H|T],[H|Initial]) :- already_done(T, Initial).

% listify(+Sudoku, -List)
% returns heuristically computed list of not-yet-set fields
% heuristics: number of already set neighbours (in time)
listify(Method, sudoku(M, N, Fields), List) :-
	already_done(Fields, Initial), !,
	subtract(Fields, Initial, FieldsZero),
	listify1(Method, sudoku(M, N, Fields), FieldsZero, Initial, List).

% listify1(+FieldsList, +SeenFieldsList, -HeuristicList)
% computional helper for listify/2
% % compute Count of neighbours for each field in Fields, 
% % % depending on current Seen
% % sort by key (the Count)
% % take first and add it to HeuristicList
listify1(_, _, [], _, []).
listify1(Method, Sudoku, Fields, Seen, [Field|ListedFields]) :-
	(Method = relatives, maplist(count_relatives(Sudoku, Seen), Fields, Tuples) ; maplist(count_ns(Seen), Fields, Tuples)),
	keysort(Tuples, SortedTuples),
	reverse(SortedTuples, ReversedSortedTuples),
	[Count-Field|_] = ReversedSortedTuples,
	delete(Fields, Field, NewFields),
	listify1(Method, Sudoku, NewFields, [Field|Seen], ListedFields), !.