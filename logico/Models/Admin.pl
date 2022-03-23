:- include('../Utils.pl').

verifica_login_senha(Login, Senha):-
    read_csv('admin.csv', Lists),
    getAdmin(Lists, Login, Senha, ListaL),
    ListaL =\= [].

getAdmin([], _, _, []).
getAdmin([[Login|[Senha|T1]]|T], Login, Senha, [Login|[Senha|T1]]).
getAdmin([_|T], Login, Senha, R) :- 
    getAdmin(T, Login, Senha, R).
