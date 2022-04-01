:- use_module(library(csv)).
:- include('../Utils.pl').
:- include('../Controller/VotacaoController.pl').

verifica_chapa_cadastrada(idChapa) :-
    read_csv('chapa.csv', Lists),
    verifica_na_lista(idChapa, Lists).


cadastrar_chapa(Nome , Numero, IdVotacao, "Chapa Cadastrada") :-
    get_csv_path('chapa.csv', CsvChapa),
    open(CsvChapa, append, File),
    gerar_id_chapa(Id),
    NumDeVotos = 0,
    writeln(File, (Id, Nome, Numero, IdVotacao, NumDeVotos)),
    close(File).

gerar_id_chapa(1) :-
    read_csv('chapa.csv', Lists),
    not(last(Lists, _)).

gerar_id_chapa(Id) :-
    read_csv('chapa.csv', Lists),
    last(Lists, [H|_]),
    Id is H + 1.


verifica_estudante_em_chapa(Matricula, Id_chapa):-
    read_csv('estudanteChapa.csv', Lists),
    get_estudante_chapa(Lists, Matricula, Id_chapa, R),
    not(eh_vazia(R)).

get_estudante_chapa([], _, _, []).
get_estudante_chapa([[Matricula|[Id_chapa|T1]]|T], Matricula, Id_chapa, [Matricula|[Id_chapa|T1]]).
get_estudante_chapa([_|T], Matricula, Id_chapa, R) :- 
    get_estudante_chapa(T, Matricula, Id_chapa, R).

cadastra_estudante_chapa(Matricula, Id_chapa):-
    get_csv_path('estudanteChapa.csv', Csv_Estudante_chapa),
    open(Csv_Estudante_chapa, append, File),
    writeln(File, (Matricula, Id_chapa)),
    close(File).

remove_estudante_chapa(Matricula, Id_chapa):-
    atom_concat('./Dados/', 'estudanteChapa.csv', Path),
    csv_read_file(Path, Rows),
    removeTupla(Matricula, Id_chapa, Rows, ListaAtualizada),
    csv_write_file(Path, ListaAtualizada).
    
verifica_chapa_cadastrada([row(Id_chapa, _, _, _, _)|T], Id_chapa).
verifica_chapa_cadastrada([H|T], Id_chapa) :-
    verifica_chapa_cadastrada(T, Id_chapa).

chapa_cadastrada(Id_chapa) :-
    atom_concat('./Dados/', 'chapa.csv', Path),
    csv_read_file(Path, Rows),
    verifica_chapa_cadastrada(Rows, Id_chapa).
get_chapas_ativas(Result) :- 
    atom_concat('./Dados/', 'chapa.csv', Path),
    csv_read_file(Path, Rows),
    filter_chapas_votacao_ativa(Rows, Result).

filter_chapas_votacao_ativa([], []).
filter_chapas_votacao_ativa([row(Id,Nome,Numero,IdVotacao,Votos)|T], [row(Id,Nome,Numero,IdVotacao,Votos)|R]) :- 
    verifica_votacao_ativa(IdVotacao),
    filter_chapas_votacao_ativa(T, R).
filter_chapas_votacao_ativa([row(_,_,_,IdVotacao,_)|T], R) :-
    not(verifica_votacao_ativa(IdVotacao)),
    filter_chapas_votacao_ativa(T, R).

adiciona_voto_csv([], _, _, []).
adiciona_voto_csv([row(Id,Nome,Numero,IdVotacao,Votos)|T], Numero, IdVotacao, Result) :-
    NewVotos is Votos + 1,
    Result = [row(Id,Nome,Numero,IdVotacao,NewVotos)|T].
adiciona_voto_csv([H|T], Numero, IdVotacao, [H|R]) :-
    adiciona_voto_csv(T, Numero, IdVotacao, [H|R]).

adiciona_voto(ChapaNumero, IdVotacao) :-
    atom_concat('./Dados/', 'chapa.csv', Path),
    csv_read_file(Path, File),
    adiciona_voto_csv(File, ChapaNumero, IdVotacao, CsvResultante),
    csv_write_file(Path, CsvResultante).

verifica_by_numero_votacao_csv([row(Id,Nome,Numero,IdVotacao,Votos)|T], Numero, IdVotacao).
verifica_by_numero_votacao_csv([H|T], Numero, IdVotacao) :- verifica_by_numero_votacao_csv(T, Numero, IdVotacao).

verifica_by_numero_votacao(Numero, IdVotacao) :-
    atom_concat('./Dados/', 'chapa.csv', Path),
    csv_read_file(Path, File),
    verifica_by_numero_votacao_csv(File, Numero, IdVotacao).

get_chapa(_, [], []).
get_chapa(Id, [[Id|T]|T2], [Id|T]).
get_chapa(Id, [[H|T]|T2], R) :- get_chapa(Id, T2, R).

get_chapa_csv(_, [], []).
get_chapa_csv(ID, [row(ID,Nome,Numero,IdVotacao,Votos)|T], row(ID,Nome,Numero,IdVotacao,Votos)).
get_chapa_csv(ID, [H|T], Chapa) :-
    get_chapa_csv(ID, T, Chapa).

get_chapa_by_id(ID, Chapa) :-
    atom_concat('./Dados/', 'chapa.csv', Path),
    csv_read_file(Path, File),
    get_chapa_csv(ID, File, Chapa).

filtra_chapas_por_votacao(_, [], []).
filtra_chapas_por_votacao(IDVotacao, [row(IDChapa, Nome, Num, IDVotacao, NumVotos) | T], [row(IDChapa, Nome, Num, IDVotacao, NumVotos) | TailResult]) :-
    filtra_chapas_por_votacao(IDVotacao, T, TailResult).
filtra_chapas_por_votacao(IDVotacao, [H|T], Chapas) :-
    filtra_chapas_por_votacao(IDVotacao, T, Chapas).

get_chapas_by_votacao(IDVotacao, Chapas) :-
    atom_concat('./Dados/', 'chapa.csv', Path),
    csv_read_file(Path, File),
    filtra_chapas_por_votacao(IDVotacao, File, Chapas).
