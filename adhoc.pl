% count_correct(+Sudoku, +Field, -Count)
% outputs Count of correct posibilities for Field in scope of Sudoku
count_correct(Sudoku, Field, Count-Field) :-
	bagof(CorrectField, correct(Sudoku, Field, CorrectField), Corrects),
	length(Corrects, Count).

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
	maplist(count_correct(sudoku(M, N, Fields)), NotDone, Rated),
	[Rate-Field|_] = Rated,
	correct(sudoku(M, N, Fields), Field, CorrectField),
	set_value(sudoku(M, N, Fields), Field, CorrectField, NewSudoku),
	adhoc(NewSudoku, Solved).