:- use_module(library(csv)).
:- include('../Utils.pl').

verifica_votacao_cadastrada(DataVotacao) :-
    read_csv('votacao.csv', Lists),
    verifica_na_lista(Lists, DataVotacao).


cadastrar_admin(DataVotacao, "Votação Cadastrada") :-
    get_csv_path('votacao.csv', Csv_Admin),
    open(Csv_Admin, append, File),
    Encerrada = false,
    Abstencoes = 0,
    Nulos = 0,
    writeln(File, (DataVotacao, Encerrada, Abstencoes, Nulos)),
    close(File).
