% count_correct(+Sudoku, +Field, -Count)
count_correct(Sudoku, Field, Count-Field) :-
	bagof(CorrectField, correct(Sudoku, Field, CorrectField), Corrects),
	length(Corrects, Count).

% not_done_yet(+In, -Out)
not_done_yet([], []).
not_done_yet([[X, Y, 0]|In],[[X, Y, 0]|Out]) :- not_done_yet(In, Out), !.
not_done_yet([_|In], Out) :- not_done_yet(In, Out), !.

% adhoc(+Sudoku, -SolvedSudoku)
adhoc(sudoku(M, N, Fields), sudoku(M, N, Fields)) :- 
	not_done_yet(Fields, ND),
	ND = [].
  
adhoc(sudoku(M, N, Fields), Solved) :-
	not_done_yet(Fields, NotDone), 
	maplist(count_correct(sudoku(M, N, Fields)), NotDone, Rated),
	member(Rate-Field, Rated),
	correct(sudoku(M, N, Fields), Field, CorrectField),
	set_value(sudoku(M, N, Fields), Field, CorrectField, NewSudoku),
	adhoc(NewSudoku, Solved).
  