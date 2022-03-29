:- include('../Dados/admin.csv').
:- include('../Models/Admin.pl').

login_admin(Login, Senha):-
    verifica_login_senha(Login, Senha).

cadastro_admin(Login, Senha, Result) :-
    (verifica_admin_cadastrado(Login) -> 
    Result = "Erro: Admin já cadastrado.";
    cadastrar_admin(Login, Senha, Result)).

remove_admin(Login, R) :-
    (verifica_admin_cadastrado(Login) -> 
    remover_admin(Login, R);
    R = "Erro: Admin não está cadastrado.").