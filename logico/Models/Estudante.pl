:- use_module(library(csv)).
:- include('../Utils.pl').

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