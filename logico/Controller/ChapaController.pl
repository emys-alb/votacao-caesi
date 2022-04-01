:- include('../Models/Estudante.pl').
:- include('../Models/Chapa.pl').

cadastrar_estudante_chapa(Matricula, Id_chapa, R) :-
    (estudante_cadastrado(Matricula) ->
        (chapa_cadastrada(Id_chapa) -> 
            (not(verifica_estudante_em_chapa(Matricula, Id_chapa)) -> 
                cadastra_estudante_chapa(Matricula, Id_chapa), R = "Estudante cadastrado na chapa";
                R = "Estudante já cadastrado na chapa");
            R = "Chapa não cadastrada");
        R = "Estudante não cadastrado"
    ).

remover_estudante_chapa(Matricula, Id_chapa, R) :-
    (estudante_cadastrado(Matricula) ->
        (chapa_cadastrada(Id_chapa) -> 
            (verifica_estudante_em_chapa(Matricula, Id_chapa) -> 
                remove_estudante_chapa(Matricula, Id_chapa), R = "Estudante removido da chapa";
                R = "Estudante não está cadastrado na chapa");
            R = "Chapa não cadastrada");
        R = "Estudante não cadastrado"
    ).
get_chapas_votacoes_ativas(Result) :- get_chapas_ativas(Result).

adiciona_voto_chapa(ChapaNum, IdVotacao) :- adiciona_voto(ChapaNum, IdVotacao).

verifica_chapa_by_numero_e_votacao(ChapaNumero, IdVotacao) :- verifica_by_numero_votacao(ChapaNumero, IdVotacao).

cadastra_chapa(Nome , Numero, IdVotacao, R) :-
    cadastrar_chapa(Nome, Numero, IdVotacao, R).

edita_nome_chapa(IdChapa, Nome, R) :-
    edita_nome(IdChapa, Nome, R).

edita_numero_chapa(IdChapa, Numero, R) :-
    edita_numero(IdChapa, Numero, R).

get_chapa_vencedora(IDVotacao, ChapaVencedora) :-
    get_chapas_by_votacao(IDVotacao, Chapas),
    get_id_chapa_mais_votos(Chapas, IDChapaVencedora),
    get_chapa_by_id(IDChapaVencedora, ChapaVencedora).

get_id_chapa_mais_votos(Chapas, IDChapaVencedora) :-
    get_mais_votos_rec(Chapas, -1, -1, IDChapaVencedora).

get_mais_votos_rec([row(IDChapa, _, _, _, NumVotos)|[]], MaiorQtdVotos, IDMaiorChapaAtual, IDChapaVencedora) :-
    ((NumVotos > MaiorQtdVotos) ->
        IDChapaVencedora = IDChapa;
        IDChapaVencedora = IDMaiorChapaAtual
    ).

get_mais_votos_rec([row(IDChapa, _, _, _, NumVotos) | T], MaiorQtdVotos, IDMaiorChapaAtual, IDChapaVencedora) :-
    ((NumVotos > MaiorQtdVotos) ->
        get_mais_votos_rec(T, NumVotos, IDChapa, IDChapaVencedora);
        get_mais_votos_rec(T, MaiorQtdVotos, IDMaiorChapaAtual, IDChapaVencedora)
    ).

get_votos_chapas_votacao(IdVotacao, Result) :- get_soma_votos_chapas_votacao(IdVotacao, Result).

remover_chapa(Id, R) :-
    (chapa_cadastrada(Id) -> 
        remove_chapa(Id), R = "Chapa removida";
    R = "Chapa não cadastrada").
