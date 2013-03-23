% count_correct(+Sudoku, +Field, -Count)
% outputs Count of correct posibilities for Field in scope of Sudoku
count_correct1(_, _, _, 0, []).

count_correct1(RowValues, ColumnValues, AreaValues, MaxPossible, [MaxPossible|Out]) :-
	\+ member(MaxPossible, RowValues),
	\+ member(MaxPossible, ColumnValues),
	\+ member(MaxPossible, AreaValues),
	Max2 is MaxPossible - 1,
	count_correct1(RowValues, ColumnValues, AreaValues, Max2, Out), !.

count_correct1(RowValues, ColumnValues, AreaValues, MaxPossible, Out) :-
	Max2 is MaxPossible - 1,
	count_correct1(RowValues, ColumnValues, AreaValues, Max2, Out), !.

count_correct(Sudoku, Field, Count-Field) :-
	Field = [X, Y, Value],
	get_row_values(Sudoku, [X, Y, Value], RowValues),
	get_column_values(Sudoku, [X, Y, Value], ColumnValues),
	get_area_values(Sudoku, [X, Y, Value], AreaValues),
	Sudoku = sudoku(M, N, _),
	MaxPossible is M * N,
	count_correct1(RowValues, ColumnValues, AreaValues, MaxPossible, Out), !,
	length(Out, Count).

% not_done_yet(+In, -Out)
% filters yet not set fields in In to Out
not_done_yet([], []).
not_done_yet([[X, Y, 0]|In],[[X, Y, 0]|Out]) :- not_done_yet(In, Out), !.
not_done_yet([_|In], Out) :- not_done_yet(In, Out), !.


% is_sudoku_finished(+Sudoku, +Fields)
% true if Sudoku with fields Fields is all correct
is_sudoku_finished(_, []).
is_sudoku_finished(Sudoku, [H|Tail]) :- correct(Sudoku, H, H), is_sudoku_finished(Sudoku, Tail), !.

% adhoc(+Sudoku, -SolvedSudoku)
% dynamic solving of sudoku
adhoc(sudoku(M, N, Fields), sudoku(M, N, Fields)) :-
	not_done_yet(Fields, NotDone),
	NotDone = [].
adhoc(sudoku(M, N, Fields), Solved) :-
	not_done_yet(Fields, NotDone),
	maplist(cc(sudoku(M, N, Fields)), NotDone, Rated),
	keysort(Rated, SortedRated),
	[Rate-Field|_] = SortedRated,
	correct(sudoku(M, N, Fields), Field, CorrectField),
	set_value(sudoku(M, N, Fields), Field, CorrectField, NewSudoku),
	adhoc(NewSudoku, Solved).