% filter_same_row(+Y, +Fields, -RowFields)
% outputs only RowFields (subset of Fields) that have equal X coordinate
filter_same_row(_, [], []).
filter_same_row(Y, [[X, Y, Value]|T], [[X, Y, Value]|Result]) :- filter_same_row(Y, T, Result).
filter_same_row(Y, [H|T], Result) :- filter_same_row(Y, T, Result).

% filter_same_column(+X, +Fields, -ColumnFields)
% outputs only ColumnFields (subset of Fields) that have equal Y coordinate
filter_same_column(_, [], []).
filter_same_column(X, [[X, Y, Value]|T], [[X, Y, Value]|Result]) :- filter_same_column(X, T, Result).
filter_same_column(X, [H|T], Result) :- filter_same_column(X, T, Result).

% filter_same_area(+X, +Y, +M, +N, +Fields, -AreaFields)
% outputs only AreaFields (subset of Fields) that are in the same area as [X, Y, _]
filter_same_area(_, _, _, _, [], []).
filter_same_area(X, Y, M, N, [[Hx, Hy, Hvalue]|T], [[Hx, Hy, Hvalue]|Result]) :- 
	(Hx div M) =:= (X div M), 
	(Hy div N) =:= (Y div N),
	filter_same_area(X, Y, M, N, T, Result).
filter_same_area(X, Y, M, N, [_|T], Result) :- filter_same_area(X, Y, M, N, T, Result).

% values_only(+Fields, -Values)
% extract third element, the value, from Fields
values_only([], []).
values_only([[_, _, Value]|T], [Value|Values]) :- values_only(T, Values).

% get_row_values(+Sudoku, +Field, -Values)
% outputs only Values in Field's row (except Field's value itself)
get_row_values(sudoku(_, _, Fields), [X, Y, Value], Values) :-
	filter_same_row(Y, Fields, Row),
	delete(Row, [X, Y, Value], CorrectRow),
	values_only(CorrectRow, Values).

% get_column_values(+Sudoku, +Field, -Values)
% outputs only Values in Field's column (except Field's value itself)
get_column_values(sudoku(_, _, Fields), [X, Y, Value], Values) :-
	filter_same_column(X, Fields, Column),
	delete(Column, [X, Y, Value], CorrectColumn),
	values_only(CorrectColumn, Values).

% get_area_values(+Sudoku, +Field, -Values)
% outputs only Values in Field's area (except Field's value itself)
get_area_values(sudoku(M, N, Fields), [X, Y, Value], Values) :-
	filter_same_area(X, Y, M, N, Fields, Area),
	delete(Area, [X, Y, Value], CorrectArea),
	values_only(CorrectArea, Values).

% set_value(+Sudoku, +Field, +NewField, -SolvedSudoku)
% replaces Field with NewField
set_value(sudoku(M, N, Fields), Field, NewField, sudoku(M, N, NewFields)) :- delete([NewField | Fields], Field, NewFields).