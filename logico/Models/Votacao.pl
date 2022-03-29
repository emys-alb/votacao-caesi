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

encerrar_votacao(IdVotacao).
    % read_csv('votacao.csv', Lists),
    % get_by_id(IdVotacao, List, Votacao),
    % remove(Votacao, Lists, NewLists),
    