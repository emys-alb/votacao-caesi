read_csv(Arquivo,Lists):-
    get_csv_path(Arquivo, Path),
    csv_read_file(Path, Rows, []),
    rows_to_lists(Rows, Lists).

get_csv_path(Arquivo, Path):-
    atom_concat('./Dados/', Arquivo, Path).

rows_to_lists(Rows, Lists):- maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
    Row =.. [row|List].

get_by_index(0, [H|_], H).
get_by_index(I, [_|T], E):- X is I - 1, get_by_index(X, T, E).

%se não funcionar, criar duas regras.
verifica_na_lista(SearchedId, [H|T]):-
    id_cadastrado(SearchedId, H);
    verifica_na_lista(SearchedId, T).

id_cadastrado(SearchedId, [SearchedId|_]).

get_cabeca([], []).
get_cabeca([H|_], H).

get_by_id(_, [], []).
get_by_id(Id, [[Id|T]|T2], [Id|T]).
get_by_id(Id, [[H|T]|T2], Result) :- get_by_id(Id, T2, Result).

remove(X, [X|T], T).
remove(X, [H|T], [H|T1]):- remove(X,T,T1).

remove_by_index(0,[_|T],T).
remove_by_index(I,[H|T],[H|T1]):- X is I - 1, remove_by_index(X, T, T1).

eh_vazia(Lista) :-
    length(Lista, X),
    X =:= 0.

limpar_csv(Arquivo) :-
    get_csv_path(Arquivo, Path),
    open(Path, write, File),
    write(File, ''),
    close(File).

removeTupla(X, Y, [row(X,Y)|T], T).
removeTupla(X, Y, [H|T], [H|T1]):- removeTupla(X,Y,T,T1).