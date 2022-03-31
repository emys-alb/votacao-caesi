:- use_module(library(csv)).
:- include('../Utils.pl').



verifica_chapa_cadastrada(idChapa) :-
    read_csv('chapa.csv', Lists),
    verifica_na_lista(idChapa, Lists).

cadastrar_chapa(Nome , Numero, "Chapa Cadastrada") :-
    get_csv_path('chapa.csv', CsvChapa),
    open(CsvChapa, append, File),
    gerar_id_chapa(Id), 
    writeln(File, (Id, Nome, Numero)),
    close(File).

gerar_id_chapa(1) :-
    read_csv('chapa.csv', Lists),
    not(last(Lists, _)).

gerar_id_chapa(Id) :-
    read_csv('chapa.csv', Lists),
    last(Lists, [H|_]),
    Id is H + 1.

get_soma_votos_chapas_votacao_csv([], _, 0).
get_soma_votos_chapas_votacao_csv([row(_,_,_,IdVotacao,Votos)|T], IdVotacao, R) :-
    get_soma_votos_chapas_votacao_csv(T, IdVotacao, R1),
    R is R1 + Votos.
get_soma_votos_chapas_votacao_csv([H|T], IdVotacao, R) :-
    get_soma_votos_chapas_votacao_csv(T, IdVotacao, R).

get_soma_votos_chapas_votacao(IdVotacao, Result) :-
    atom_concat('./Dados/', 'chapa.csv', Path),
    csv_read_file(Path, File),
    get_soma_votos_chapas_votacao_csv(File, IdVotacao, Result).