:- include('../Models/Votacao.pl').

cadastro_votacao(DataVotacao, IdVotacao, Result) :-
    cadastrar_votacao(DataVotacao, IdVotacao, Result).

encerra_votacao(IdVotacao, "ID não encontrado.") :-
    not(verifica_votacao_cadastrada(IdVotacao)).

encerra_votacao(IdVotacao, "Votação encerrada.") :-
    encerrar_votacao(IdVotacao).

verifica_votacao_ativa(IdVotacao) :- is_votacao_ativa(IdVotacao).

adiciona_voto_nulo_votacao(IdVotacao) :- adiciona_voto_nulo(IdVotacao).

get_dados_votacao(IDVotacao, Result) :-
    dados_votacao(IDVotacao, Result).

get_votacoes(Result) :-
    get_all_votacoes(Result).
