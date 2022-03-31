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

cadastra_chapa(Nome , Numero, R) :-
    cadastrar_chapa(Nome , Numero,R).
