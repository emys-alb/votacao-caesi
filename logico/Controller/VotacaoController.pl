:- include('../Models/Votacao.pl').

cadastro_votacao(DataVotacao, Result) :-
    cadastrar_votacao(DataVotacao, Result).

encerra_votacao(IdVotacao, "ID não encontrado.") :-
    not(verifica_votacao_cadastrada(IdVotacao)).

encerra_votacao(IdVotacao, "Votação encerrada.") :-
    encerrar_votacao(IdVotacao).

get_dados_votacao(IDVotacao, Result) :-
    
    dados_votacao(IDVotacao, Result).
