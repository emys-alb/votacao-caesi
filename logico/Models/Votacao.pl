:- use_module(library(csv)).
:- include('../Utils.pl').

verifica_votacao_cadastrada(IdVotacao) :-
    read_csv('votacao.csv', Lists),
    verifica_na_lista(IdVotacao, Lists).

cadastrar_votacao(DataVotacao, "Votação Cadastrada") :-
    get_csv_path('votacao.csv', CsvVotacao),
    open(CsvVotacao, append, File),
    gerar_id_votacao(Id),
    Encerrada = false,
    Abstencoes = 0,
    Nulos = 0,
    writeln(File, (Id, DataVotacao, Encerrada, Abstencoes, Nulos)),
    close(File).

gerar_id_votacao(1) :-
    read_csv('votacao.csv', Lists),
    not(last(Lists, _)).

gerar_id_votacao(Id) :-
    read_csv('votacao.csv', Lists),
    last(Lists, [H|_]),
    Id is H + 1.

encerrar_votacao_csv([], _, []).
encerrar_votacao_csv([row(IdVotacao, D, _, A, N)|T], IdVotacao, [row(IdVotacao, D, true, A, N)|T]).
encerrar_votacao_csv([H|T], IdVotacao, [H|NewTail]) :-
    encerrar_votacao_csv(T, IdVotacao, NewTail).

encerrar_votacao(IdVotacao) :-
    atom_concat('./Dados/', 'votacao.csv', Path),
    csv_read_file(Path, File),
    encerrar_votacao_csv(File, IdVotacao, CsvResultante),
    csv_write_file(Path, CsvResultante).
    
is_votacao_ativa(Id) :-
    read_csv('votacao.csv', Votacoes),
    get_by_id(Id, Votacoes, [_|[_|[Encerrada|_]]]),
    not(Encerrada).

adiciona_voto_nulo_csv([], _, []).
adiciona_voto_nulo_csv([row(IdVotacao, D, E, A, N)|T], IdVotacao, Result) :-
    NewNulos is N + 1,
    Result = [row(IdVotacao, D, E, A, NewNulos)|T].
adiciona_voto_nulo_csv([H|T], IdVotacao, [H|NewTail]) :-
    adiciona_voto_nulo_csv(T, IdVotacao, NewTail).

adiciona_voto_nulo(IdVotacao) :-
    atom_concat('./Dados/', 'votacao.csv', Path),
    csv_read_file(Path, File),
    adiciona_voto_nulo_csv(File, IdVotacao, CsvResultante),
    csv_write_file(Path, CsvResultante). 