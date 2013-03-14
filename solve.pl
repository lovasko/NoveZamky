correct(Sudoku, Field, CorrectField) :-
	get_row_values(Sudoku, Field, RowValues),
	get_column_values(Sudoku, Field, ColumnValues),
	get_area_values(Sudoku, Field, AreaValues),
	Sudoku = sudoku(M, N, _),
	MaxPossible is M * N,
	!,
	between(1, MaxPossible, Correct),
	\+ member(Correct, RowValues),
	\+ member(Correct, ColumnValues),
	\+ member(Correct, AreaValues),
	Field = [X, Y, _],
	CorrectField = [X, Y, Correct].

solve(Sudoku, [], Sudoku).
solve(Sudoku, [H|OrderTail], SolvedSudoku) :-
	correct(Sudoku, H, Correct),
	set_value(Sudoku, H, Correct, NewSudoku),
	solve(NewSudoku, OrderTail, SolvedSudoku).