:- include('../Models/Chapa.pl').
:- include('../Models/Estudante.pl').

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
