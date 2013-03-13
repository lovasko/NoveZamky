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
  
correct(Sudoku, Field, Correct) :-
  get_row_values(Sudoku, Field, RowValues),
  get_column_values(Sudoku, Field, ColumnValues),
  get_area_values(Sudoku, Field, AreaValues),
  Sudoku = sudoku(M, N, _),
  MaxPossible is M * N,
  !,
  between(1, MaxPossible, Correct),
  \+ member(Correct, RowValues),
  \+ member(Correct, ColumnValues), 
  \+ member(Correct, AreaValues).

is_neighbour([X1, Y1, _], [X2, Y2, _]) :-
  abs(X1 - X2) =< 1, abs(Y1 - Y2) =< 1.

% neighbours for field  
nff([], _, []).
nff([H|T], Field, [H|Ns]) :-
  is_neighbour(H, Field), 
  nff(T, Field, Ns).
nff([H|T], Field, Ns) :-
  nff(T, Field, Ns).

% count neighbours
count_ns(Fields, Field, Tuple) :- 
  nff(Fields, Field, Ns), 
  length(Ns, Count), 
  Tuple = Count-Field.

listify1([], _, []).
listify1(Fields, Seen, [Field|ListedFields]) :-
  maplist(count_ns(Seen), Fields, Tuples),
  keysort(Tuples, SortedTuples),
  reverse(SortedTuples, ReversedSortedTuples),
  [Count-Field|_] = ReversedSortedTuples,
  print(Field),
  delete(Fields, Field, NewFields),
  listify1(NewFields, [Field|Seen], ListedFields).

already_done([], []).
already_done([H|T], Initial) :-
  H = [_, _, 0], 
  already_done(T, Initial).
already_done([H|T], [H|Initial]) :- 
  already_done(T, Initial).
  
subtract([], _, []) :- !.
subtract([A|C], B, D) :-
  memberchk(A, B), !,
  subtract(C, B, D).
subtract([A|B], C, [A|D]) :-
  subtract(B, C, D).  
  
listify(Sudoku, List) :-
  Sudoku = sudoku(_, _, Fields),
  already_done(Fields, Initial),
  subtract(Fields, Initial, FieldsZero),
  listify1(FieldsZero, Initial, List).