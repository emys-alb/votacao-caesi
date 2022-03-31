:- include('../Models/Chapa.pl').

cadastro_chapa(DataChapa, Result) :-
    cadastrar_chapa(DataChapa, Result).

get_chapas_votacoes_ativas(Result) :- get_chapas_ativas(Result).

adiciona_voto_chapa(ChapaNum, IdVotacao) :- adiciona_voto(ChapaNum, IdVotacao).

verifica_chapa_by_numero_e_votacao(ChapaNumero, IdVotacao) :- verifica_by_numero_votacao(ChapaNumero, IdVotacao).

cadastra_chapa(Nome , Numero, R) :-
    cadastrar_chapa(Nome , Numero,R).
