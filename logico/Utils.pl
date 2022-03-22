read_csv(Arquivo,Lists):-
    atom_concat('./Dados/', Arquivo, Path),
    csv_read_file(Path, Rows, []),
    rows_to_lists(Rows, Lists).

rows_to_lists(Rows, Lists):- maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
    Row =.. [row|List].

get_by_index(0, [H|_], H).
get_by_index(I, [_|T], E):- X is I - 1, get_by_index(X, T, E).

%se não funcionar, criar duas regras.
verifica_na_lista(SearchedId, [H|T]):-
     id_cadastrado(SearchedId, H);
     verifica_na_lista(SearchedId, T).

id_cadastrado(SearchedId, [H|T]):-
    H =:= SearchedId.

get_cabeca([], []).
get_cabeca([H|T], H).

get_by_id(_, [], []).
get_by_id(Id, [[H|T]|T2], Result) :-
    (H =:= Id 
        -> Result = [H|T];
        get_by_id(Id, T2, Result)).

remove(X, [X|T], T).
remove(X, [H|T], [H|T1]):- remove(X,T,T1).

remove_by_index(0,[_|T],T).
remove_by_index(I,[H|T],[H|T1]):- X is I - 1, remove_by_index(X, T, T1).