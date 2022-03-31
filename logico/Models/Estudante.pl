:- use_module(library(csv)).
:- include('../Utils.pl').

verifica_matricula_senha(Matricula, Senha):-
    read_csv('estudante.csv', Lists),
    get_estudante(Lists, Matricula, Senha, R),
    not(eh_vazia(R)).

get_estudante([], _, _, []).
get_estudante([[Matricula|[Senha|T1]]|T], Matricula, Senha, [Matricula|[Senha|T1]]).
get_estudante([_|T], Matricula, Senha, R) :- 
    get_estudante(T, Matricula, Senha, R).

cadastrar_estudante(Matricula, Senha) :-
    get_csv_path('estudante.csv', Csv_Estudante),
    open(Csv_Estudante, append, File),
    writeln(File, (Matricula, Senha, true)),
    close(File).

verifica_estudante_cadastrado(Matricula):-
    read_csv('estudante.csv', Estudantes),
    verifica_na_lista(Matricula, Estudantes).

desativa_estudante_csv([], _, []).
desativa_estudante_csv([row(Matricula, Senha, _)|T], Matricula, [row(Matricula, Senha, false)|T]).
desativa_estudante_csv([H|T], Matricula, [H|Out]) :- desativa_estudante_csv(T, Matricula, Out).

desativa_estudante(Matricula) :-
    atom_concat('./Dados/', 'estudante.csv', Path),
    csv_read_file(Path, File),
    desativa_estudante_csv(File, Matricula, Saida),
    csv_write_file(Path, Saida).

is_votante(Matricula) :-
    read_csv('estudante.csv', Estudantes),
    get_by_id(Matricula, Estudantes, [_|[_|[Votante]]]),
    Votante.

edita_senha_estudante(Matricula, NovaSenha) :-
    atom_concat('./Dados/', 'estudante.csv', Path),
    csv_read_file(Path, File),
    edita_senha_estudante_csv(File, Matricula, NovaSenha, Saida),
    csv_write_file(Path, Saida).

edita_senha_estudante_csv([], _, _,[]).
edita_senha_estudante_csv([row(Matricula, _, Votante)|T], Matricula, NovaSenha, [row(Matricula, NovaSenha, Votante)|T]).
edita_senha_estudante_csv([H|T], Matricula, NovaSenha, [H|Out]) :- edita_senha_estudante_csv(T, Matricula, NovaSenha, Out).

get_votantes_csv([], 0).
get_votantes_csv([row(_,_,true)|T], R) :- get_votantes_csv(T, R1), R is R1 + 1.
get_votantes_csv([H|T], R) :- get_votantes_csv(T,R).

get_quantidade_votantes(Qtd) :-
    atom_concat('./Dados/', 'estudante.csv', Path),
    csv_read_file(Path, File),
    get_votantes_csv(File, Qtd).
