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
  [X, Y, Value] = H,
  NewAccu = [ Value | Accu ],
  values_only(T, NewAccu, Result).

get_row_values(Sudoku, Y, Values) :-
  Sudoku = sudoku(M, N, Fields),
  filter_same_row(Y, Fields, [], Row),
  values_only(Row, [], Values).
  
get_column_values(Sudoku, X, Values) :-
  Sudoku = sudoku(M, N, Fields),
  filter_same_column(X, Fields, [], Column),
  values_only(Column, [], Values).
  
get_area_values(Sudoku, X, Y, Values) :-
  Sudoku = sudoku(M, N, Fields),
  filter_same_area(X, Y, M, N, Fields, [], Area),
  % TODO remove [X, Y, _]
  values_only(Area, [], Values).