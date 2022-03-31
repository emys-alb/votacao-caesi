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

get_chapas_ativas(Result) :- 
    atom_concat('./Dados/', 'chapa.csv', Path),
    csv_read_file(Path, Rows),
    filter_chapas_votacao_ativa(Rows, Result).

get_all(Chapa, Id, Nome, Numero, IdVotacao, NumDeVotos) :-
    get_by_index(0, Chapa, Id),
    get_by_index(1, Chapa, Nome),
    get_by_index(2, Chapa, Numero),
    get_by_index(3, Chapa, IdVotacao),
    get_by_index(4, Chapa, NumDeVotos).

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

edita_nome(IdChapa, NovoNome, "Chapa alterada com sucesso") :-
    get_chapas_ativas(Chapas),
    get_chapa(IdChapa, Chapas, [Id, Nome, Numero, IdVotacao, NumDeVotos]),
    remove(IdChapa, Chapas, Lista),  %troca por remove_chapa
    limpar_csv('chapa.csv'),
    reescrever_csv_chapa(Lista),
    recadastra_chapa(Id, NovoNome, Numero, IdVotacao, NumDeVotos).

edita_numero(IdChapa, NovoNumero, "Chapa alterada com sucesso") :-
    get_chapas_ativas(Chapas),
    get_chapa(IdChapa, Chapas, [Id, Nome, Numero, IdVotacao, NumDeVotos]).
    remove(IdChapa, Chapas, Lista), %troca por remove_chapa
    limpar_csv('chapa.csv'),
    reescrever_csv_chapa(Lista),
    recadastra_chapa(Id, Nome, NovoNumero, IdVotacao, NumDeVotos).

reescrever_csv_chapa([]).
reescrever_csv_chapa([H|T]) :-
    get_all(H, Id, Nome, Numero, IdVotacao, NumDeVotos),
    recadastra_chapa(Id, Nome, Numero, IdVotacao, NumDeVotos),
    reescrever_csv_chapa(T).

recadastra_chapa(Id, Nome, Numero, IdVotacao, NumDeVotos) :-
    get_csv_path('chapa.csv', CsvChapa),
    open(CsvChapa, append, File),
    writeln(File, (Id, Nome, Numero, IdVotacao, NumDeVotos)),
    close(File).
