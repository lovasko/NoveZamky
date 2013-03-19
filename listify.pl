:- include('neighbours.pl').
:- include('relatives.pl').

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