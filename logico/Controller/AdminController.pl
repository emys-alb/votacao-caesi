:- include('../Dados/admin.csv').
:- include('../Models/Admin.pl').

login_admin(Login, Senha):-
    verifica_login_senha(Login, Senha).

cadastro_admin(Login, Senha, Result) :-
    (verifica_admin_cadastrado(Login) -> 
    Result = "Erro: Admin já cadastrado.";
    cadastrar_admin(Login, Senha, Result)).
