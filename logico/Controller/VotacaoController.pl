:- include('../Models/Votacao.pl').

cadastro_votacao(DataVotacao, Result) :-
    (verifica_votacao_cadastrada(DataVotacao) ->
    Result = "Erro: Votação já cadastrada.";
    cadastrar_admin(DataVotacao, Result)).
