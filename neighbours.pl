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