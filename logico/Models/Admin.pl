:- use_module(library(csv)).
:- include('../Utils.pl').

verifica_login_senha(Login, Senha):-
    read_csv('admin.csv', Lists),
    get_admin(Lists, Login, Senha, R),
    not(eh_vazia(R)).

verifica_admin_cadastrado(Login):-
    read_csv('admin.csv', Admins),
    verifica_na_lista(Login, Admins).


get_admin([], _, _, []).
get_admin([[Login|[Senha|T1]]|T], Login, Senha, [Login|[Senha|T1]]).
get_admin([_|T], Login, Senha, R) :- 
    get_admin(T, Login, Senha, R).


cadastrar_admin(Login, Senha, R) :-
    get_csv_path('admin.csv', Csv_Admin),
    open(Csv_Admin, append, File),
    writeln(File, (Login, Senha)),
    close(File),
    R = "Admin cadastrado.".