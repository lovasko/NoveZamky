list_empty([]).

print_list([]) :- print('.').
print_list([H|T]) :-
	print(H),
	print_list(T).

getopt(File) :-
	argument_list(ArgumentList),
	(list_empty(ArgumentList),
		print('Write file name containig sudoku: '),
		read_token(File)
	)
	;
	(
		argument_value(1, File)
	).