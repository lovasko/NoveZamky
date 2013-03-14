filter_same_row(_, [], Accu, Accu).
filter_same_row(Y, [H|T], Accu, Row) :-
	[_, Hy, _] = H,
	(Hy = Y,
		NewAccu = [ H | Accu ],
		filter_same_row(Y, T, NewAccu, Row)
	; 
		filter_same_row(Y, T, Accu, Row)).

filter_same_column(_, [], Accu, Accu).
filter_same_column(X, [H|T], Accu, Column) :-
	[Hx, _, _] = H,
	(Hx = X,
		NewAccu = [ H | Accu ],
		filter_same_column(X, T, NewAccu, Column)
	;	
		filter_same_column(X, T, Accu, Column)).

filter_same_area(_, _, _, _, [], Accu, Accu).
filter_same_area(X, Y, M, N, [H|T], Accu, Area) :-
	[Hx, Hy, _] = H,
	((Hx div M) =:= (X div M), (Hy div N) =:= (Y div N),
		NewAccu = [ H | Accu ],
		filter_same_area(X, Y, M, N, T, NewAccu, Area)
	;
		filter_same_area(X, Y, M, N, T, Accu, Area)).

values_only([], Accu, Accu).
values_only([H|T], Accu, Result) :-
	[_, _, Value] = H,
	NewAccu = [ Value | Accu ],
	values_only(T, NewAccu, Result).

get_row_values(Sudoku, Field, Values) :-
	Sudoku = sudoku(_, _, Fields),
	Field = [_, Y, _],
	filter_same_row(Y, Fields, [], Row),
	delete(Row, Field, CorrectRow),
	values_only(CorrectRow, [], Values).

get_column_values(Sudoku, Field, Values) :-
	Sudoku = sudoku(_, _, Fields),
	Field = [X, _, _],
	filter_same_column(X, Fields, [], Column),
	delete(Column, Field, CorrectColumn),
	values_only(CorrectColumn, [], Values).

get_area_values(Sudoku, Field, Values) :-
	Sudoku = sudoku(M, N, Fields),
	Field = [X, Y, _],
	filter_same_area(X, Y, M, N, Fields, [], Area),
	delete(Area, Field, CorrectArea),
	values_only(CorrectArea, [], Values).

set_value(Sudoku, Field, NewField, NewSudoku) :-
	Sudoku = sudoku(M, N, Fields),
	NewFields = [NewField|Fields],
	delete(NewFields, Field, FinalFields),
	NewSudoku = sudoku(M, N, FinalFields).

