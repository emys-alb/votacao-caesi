:- use_module(library(csv)).
:- include('../Utils.pl').

verifica_votacao_csv(IdVotacao, [row(IdVotacao, _, _, _, _)|_]).
verifica_votacao_csv(IdVotacao, [H|T]) :-
    verifica_votacao_csv(IdVotacao, T).

verifica_votacao_cadastrada(IdVotacao) :-
    atom_concat('./Dados/', 'votacao.csv', Path),
    csv_read_file(Path, File),
    verifica_votacao_csv(IdVotacao, File).

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

get_row_votacao([], _, []).
get_row_votacao([row(IDVotacao, DataVotacao, Encerrada, Abstencoes, Nulos)|_], IDVotacao, row(IDVotacao, DataVotacao, Encerrada, Abstencoes, Nulos)).
get_row_votacao([H|T], IDVotacao, Result) :-
    get_row_votacao(T, IDVotacao, Result).

dados_votacao(IDVotacao, Result) :-
    atom_concat('./Dados/', 'votacao.csv', Path),
    csv_read_file(Path, File),
    get_row_votacao(File, IDVotacao, Result).

get_all_votacoes(Result) :-
    atom_concat('./Dados/', 'votacao.csv', Path),
    csv_read_file(Path, Result).
