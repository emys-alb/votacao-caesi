:- include('../Dados/admin.csv').
:- include('../Models/Admin.pl').

login_admin(Login, Senha):-
    verifica_login_senha(Login, Senha).


