:- include('../Models/Chapa.pl').

cadastro_chapa(DataChapa, Result) :-
    cadastrar_chapa(DataChapa, Result).

get_chapas_votacoes_ativas(Result) :- get_chapas_ativas(Result).

adiciona_voto_chapa(ChapaNum, IdVotacao) :- adiciona_voto(ChapaNum, IdVotacao).