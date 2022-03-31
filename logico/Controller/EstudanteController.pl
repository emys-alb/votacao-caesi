:- include('../Utils.pl').
:- include('../Models/Estudante.pl').

login_estudante(Matricula, Senha):-
    verifica_matricula_senha(Matricula, Senha).

cadastro_estudantes(Caminho, Result) :-
    (not(exists_file(Caminho)) -> 
    Result = "Erro: Arquivo não existe.";
    le_e_cadastra_estudantes(Caminho),
    Result = "Estudantes cadastrados").

cadastraTodos([]).
cadastraTodos([[Matricula|[Senha|_]]|T]) :-
    (verifica_estudante_cadastrado(Matricula) -> 
    format("Estudante com matrícula ~q já cadastrado\n", [Matricula]);
    cadastrar_estudante(Matricula,Senha)),
    cadastraTodos(T).

le_e_cadastra_estudantes(Caminho) :-
    csv_read_file(Caminho, Rows, []),
    rows_to_lists(Rows, [H|T]),
    cadastraTodos(T). % remove headers

desativar_estudante(Matricula, R) :-
    (verifica_estudante_cadastrado(Matricula) ->
        (is_votante(Matricula) -> 
            desativa_estudante(Matricula), R = "Estudante desativado";
            R = "Estudante já desativado");
        R = "Estudante não cadastrado"
    ).

editar_senha_estudante(Matricula, NovaSenha, R) :-
    (verifica_estudante_cadastrado(Matricula) ->
        (edita_senha_estudante(Matricula, NovaSenha), R = "Senha editada");
        R = "Estudante não cadastrado"
    ).

get_quantidade_estudantes_votantes(Result) :- get_quantidade_votantes(Result).