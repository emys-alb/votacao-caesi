:- include('../Dados/admin.csv').
:- include('../Models/admin.pl').

login_admin(Login, Senha):-
    getAdmin(Login, Senha).


