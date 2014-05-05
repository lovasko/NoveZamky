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