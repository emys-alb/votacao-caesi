:- use_module(library(csv)).
:- include('../Utils.pl').
:- include('../Controller/VotacaoController.pl').

verifica_chapa_cadastrada(DataChapa) :-
    read_csv('chapa.csv', Lists),
    verifica_na_lista(DataChapa, Lists).

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