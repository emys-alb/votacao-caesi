:- use_module(library(csv)).
:- include('../Utils.pl').

cadastrar_chapa(Nome , Numero, "Chapa Cadastrada") :-
    get_csv_path('chapa.csv', CsvChapa),
    open(CsvChapa, append, File),
    gerar_id_chapa(Id), 
    writeln(File, (Id, Nome, Numero)),
    close(File).

gerar_id_chapa(1) :-
    read_csv('chapa.csv', Lists),
    not(last(Lists, _)).

gerar_id_chapa(Id) :-
    read_csv('chapa.csv', Lists),
    last(Lists, [H|_]),
    Id is H + 1.

verifica_estudante_em_chapa(Matricula, Id_chapa):-
    read_csv('estudanteChapa.csv', Lists),
    get_estudante_chapa(Lists, Matricula, Id_chapa, R),
    not(eh_vazia(R)).

get_estudante_chapa([], _, _, []).
get_estudante_chapa([[Matricula|[Id_chapa|T1]]|T], Matricula, Id_chapa, [Matricula|[Id_chapa|T1]]).
get_estudante_chapa([_|T], Matricula, Id_chapa, R) :- 
    get_estudante_chapa(T, Matricula, Id_chapa, R).

cadastra_estudante_chapa(Matricula, Id_chapa):-
    get_csv_path('estudanteChapa.csv', Csv_Estudante_chapa),
    open(Csv_Estudante_chapa, append, File),
    writeln(File, (Matricula, Id_chapa)),
    close(File).

remove_estudante_chapa(Matricula, Id_chapa):-
    atom_concat('./Dados/', 'estudanteChapa.csv', Path),
    csv_read_file(Path, Rows),
    %get_estudante_chapa(EstudantesChapa, Matricula, Id_chapa, R),
    removeTupla(Matricula, Id_chapa, Rows, ListaAtualizada),
    csv_write_file(Path, ListaAtualizada).
    
verifica_chapa_cadastrada([row(Id_chapa, _, _)|T], Id_chapa).
verifica_chapa_cadastrada([H|T], Id_chapa) :-
    verifica_chapa_cadastrada(T, Id_chapa).

chapa_cadastrada(Id_chapa) :-
    atom_concat('./Dados/', 'chapa.csv', Path),
    csv_read_file(Path, Rows),
    verifica_chapa_cadastrada(Rows, Id_chapa).