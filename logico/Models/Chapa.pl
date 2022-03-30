:- use_module(library(csv)).
:- include('../Utils.pl').



verifica_chapa_cadastrada(DataChapa) :-
    read_csv('chapa.csv', Lists),
    verifica_na_lista(DataChapa, Lists).

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