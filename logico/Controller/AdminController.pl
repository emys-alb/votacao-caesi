:- include('../Dados/admin.csv').
:- include('../Models/admin.pl').

login_admin(Login, Senha):-
    verifica_login_senha(Login, Senha).


