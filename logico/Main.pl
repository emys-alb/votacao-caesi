:- (initialization main).
:-include('./Utils.pl').
:-include('Controller/AdminController.pl').
:-include('Controller/VotacaoController.pl').

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

%Opcoes Principais
opcao_escolhida_principal(1) :- 
    writeln("Login Admin"),
    writeln("Insira seu login:"),
    read(Login),
    writeln("Insira sua senha:"),
    read(Senha),
    login_admin(Login, Senha),
    tty_clear,
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).

opcao_escolhida_principal(6) :- 
    writeln("Encerrando o sistema"),
    halt.

% Opcoes Admin
opcao_escolhida_admin(1) :- 
    writeln("Cadastro Admin"),
    writeln("Insira login do novo admin:"),
    read(Login),
    writeln("Insira senha do novo admin:"),
    read(Senha),
    tty_clear,
    cadastro_admin(Login, Senha, R),
    writeln(R), 
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).

opcao_escolhida_admin(6) :-
    writeln("Cadastro de votação"),
    writeln("Insira a data da nova votação:"),
    read(DataVotacao),
    cadastro_votacao(DataVotacao, R),
    tty_clear,
    writeln(R),
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).

opcao_escolhida_admin(8) :-
    writeln("Encerrar votação"),
    writeln("Insira o id da votação que deseja encerrar:"),
    read(IdVotacao),
    encerra_votacao(IdVotacao, R),
    tty_clear,
    writeln(R),
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).

opcao_escolhida_admin(9) :- 
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).
