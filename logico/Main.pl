:- (initialization main).
:-include('./Utils.pl').
:-include('Controller/AdminController.pl').

main :- 
    menu_principal,
    halt.

menu_principal :-
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).

opcoes_menu_principal() :-
    tty_clear,
    writeln("MENU PRINCIPAL"),
    writeln("[1] Login como administrador"),
    writeln("[2] Login como estudante"),
    writeln("[3] Lista dados da votação"),
    writeln("[4] Lista histórico de votações"),
    writeln("[5] Compara votações"),
    writeln("[6] Sair\n").

opcoes_menu_admin() :-
    tty_clear,
    writeln("MENU ADMIN"),
    writeln("[1] Cadastra administrador"),
    writeln("[2] Remove administrador"),
    writeln("[3] Edita senha do administrador"),
    writeln("[4] Cadastra estudantes"),
    writeln("[5] Desativa estudante"),
    writeln("[6] Cadastro de votação"),
    writeln("[7] Edita votação"),
    writeln("[8] Encerra votação"),
    writeln("[9] Voltar para o menu principal\n").

opcoes_menu_estudante() :-
    tty_clear,
    writeln("MENU Estudante"),
    writeln("[1] Edita senha do estudante"),
    writeln("[2] Cadastra voto de estudante"),
    writeln("[3] Voltar para o menu principal\n").

opcao_escolhida_principal(1) :- 
    writeln("Login Admin"),
    writeln("Insira seu login:"),
    read(Login),
    writeln("Insira sua senha:"),
    read(Senha),
    login_admin(Login, Senha), 
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).

opcao_escolhida_principal(6) :- 
    writeln("Encerrando o sistema"),
    halt.

opcao_escolhida_admin(9) :- 
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).
