filter_same_row(_, [], Accu, Accu).
filter_same_row(Y, [H|T], Accu, Row) :-
  [_, Hy, _] = H, 
  (Hy = Y, 
    NewAccu = [ H | Accu ], 
    filter_same_row(Y, T, NewAccu, Row) 
  ; 
    filter_same_row(Y, T, Accu, Row)).

%fsr(_, [], []).    
%fsr(Y, [[X, Y, Value]|T], [[X, Y, Value]|Rest]) :- fsr(Y, T, Rest).
%fsr(Y, [H|T], Rest) :- fsr(Y, T, Rest).
    
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

% zober uz doteraz vyplnene
% % spocitaj pre kazde nevyplnene vyplnenych susedov
% % vyber najviac zo susedmi v liste hotovych, daj ho do listu hotovych
% % zavolaj sa na zbytok zoznamu okrem toho prvku

% pamatame si kde sme uz boli, pricom zaciname s already_done.
% zober prvok s najvacsim poctom prvkov na riadku/stlpci/arei medzi videnymi
% tento prvok vloz do videnych,
% na zbytok prvkov zavolaj "zober prvok s najvacsim ..."

%VITAZ
% na zaciatku ohodnot podla susedov - daj len nulove Values
% dvojice [Field, Neighbours]
% % prejdi a najdi najvacsie Neighbours
% % prejdi a nastav jeho susedom vacsi Neighbours
% % daj ho do listu
% % prejdi a najdi najvacsie Neighbours
  %% aka je koncova podmienka? ked Seen + Initial = Fields

is_neighbour([X1, Y1, _], [X2, Y2, _]) :-
  abs(X1 - X2) =< 1, abs(Y1 - Y2) =< 1.

neighbours_for_field([], _, 0).
neighbours_for_field([H|T], Field, Count) :-
  is_neighbour(H, Field),
  NewCount is Count + 1,
  neighbours_for_field(T, Field, NewCount)
  ;
  neighbours_for_field(T, Field, Count).
  
% spocitaj pre kazdeho pocet susedov z videnych
% vysortuj
% zober najvacsieho, odstran ho, daj ho do videnych  
% rekurzia

%nff([], _, 0).
%nff([H|T], Field, Count) :- is_neighbour(H, Field), NC is Count + 1.
%nff([H|T], Field, Count) :- nff(T, Field, Count). 

nff([], _, []).
nff([H|T], Field, [H|Ns]) :- is_neighbour(H, Field), nff(T, Field, Ns).
nff([H|T], Field, Ns) :- nff(T, Field, Ns).

count_ns(Fields, Field, Tuple) :- nff(Fields, Field, Ns), length(Ns, Count), Tuple = Count-Field.


listify1([], _, []).
listify1(Fields, Seen, [Field|ListedFields]) :-
  maplist(count_ns(Seen), Fields, Tuples),
  keysort(Tuples, SortedTuples),
  reverse(SortedTuples, ReversedSortedTuples),
  [First|_] = ReversedSortedTuples,
  Count-Field = First,
  print(Field),
  delete(Fields, Field, NewFields),
  listify1(NewFields, [Field|Seen], ListedFields).

already_done([], []).
already_done([H|T], Initial) :-
  H = [_, _, Value], Value = 0, already_done(T, Initial).
already_done([H|T], [H|Initial]) :- already_done(T, Initial).
  
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
  
  
  
  