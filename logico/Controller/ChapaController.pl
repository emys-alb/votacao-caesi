:- include('../Models/Chapa.pl').

get_chapas_votacoes_ativas(Result) :- get_chapas_ativas(Result).

adiciona_voto_chapa(ChapaNum, IdVotacao) :- adiciona_voto(ChapaNum, IdVotacao).

verifica_chapa_by_numero_e_votacao(ChapaNumero, IdVotacao) :- verifica_by_numero_votacao(ChapaNumero, IdVotacao).

cadastra_chapa(Nome , Numero, IdVotacao, R) :-
    cadastrar_chapa(Nome, Numero, IdVotacao, R).

remover_chapa(Id, R) :-
    (chapa_cadastrada(Id) -> 
        remove_chapa(Id), R = "Chapa removida";
    R = "Chapa não cadastrada").