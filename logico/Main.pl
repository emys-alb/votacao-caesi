:- (initialization main).
:-include('./Utils.pl').
:-include('Controller/AdminController.pl').
:-include('Controller/VotacaoController.pl').
:-include('Controller/EstudanteController.pl').
:-include('Controller/ChapaController.pl').

main :- 
    menu_principal,
    halt.
menu_principal :-
    tty_clear,
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).
opcoes_menu_principal() :-
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
    writeln("MENU Estudante"),
    writeln("[1] Edita senha do estudante"),
    writeln("[2] Cadastra voto de estudante"),
    writeln("[3] Voltar para o menu principal\n").
opcao_menu_cadastro_votacao() :-
    writeln("MENU Votação"),
    writeln("[1] Adiciona estudante na chapa"),
    writeln("[2] Cadastra outra chapa"),
    writeln("[3] Encerrar cadastro de votação\n").

%Opcoes Principais
opcao_escolhida_principal(1) :- 
    writeln("Login Admin"),
    writeln("Insira seu login:"),
    read(Login),
    writeln("Insira sua senha:"),
    read(Senha),
    (login_admin(Login, Senha) ->
        (tty_clear,
        opcoes_menu_admin,
        read(Opcao),
        opcao_escolhida_admin(Opcao));
        (tty_clear,
        (writeln("Admin não cadastrado"),
        opcoes_menu_principal,
        read(Opcao),
        opcao_escolhida_principal(Opcao)))
    ).

opcao_escolhida_principal(2) :- 
    writeln("Login Estudante"),
    writeln("Insira sua matrícula:"),
    read(Matricula),
    writeln("Insira sua senha:"),
    read(Senha),
    (login_estudante(Matricula, Senha) -> 
        (tty_clear,
        opcoes_menu_estudante,
        read(Opcao),
        opcao_escolhida_estudante(Opcao, Matricula));
        tty_clear,
        (writeln("Estudante não cadastrado"),
        opcoes_menu_principal,
        read(Opcao),
        opcao_escolhida_principal(Opcao))
    ).

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

opcao_escolhida_admin(2) :- 
    writeln("Remove administrador"),
    writeln("Insira login do admin a ser removido:"),
    read(Login),
    tty_clear,
    remove_admin(Login, R),
    writeln(R), 
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).

opcao_escolhida_admin(3) :- 
    writeln("Edita senha do administrador"),
    writeln("Insira login do admin a ser editado:"),
    read(Login),
    writeln("Insira sua nova senha:"),
    read(NovaSenha),
    tty_clear,
    edita_admin(Login, NovaSenha, R),
    writeln(R), 
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).

opcao_escolhida_admin(4) :- 
    writeln("Cadastro Estudantes"),
    writeln("Insira o caminho (entre aspas simples ou duplas) para o arquivo .csv que deve conter duas colunas (matricula e senha) para cada estudante"),
    read(Caminho),
    tty_clear,
    cadastro_estudantes(Caminho, R),
    writeln(R), 
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).

opcao_escolhida_admin(5) :- 
    writeln("Desativar Estudante"),
    writeln("Insira a matrícula do estudante que será desativado"),
    read(Matricula),
    tty_clear,
    desativar_estudante(Matricula, R),
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
    opcao_menu_cadastro_votacao(),
    read(Opcao),
    opcao_escolhida_votacao(Opcao),    %fazer cadastrar chapa fica dentro da opção 1 
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
    tty_clear,
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).
%Opcoes Estudante
opcao_escolhida_estudante(1, Matricula) :- 
    writeln("Edita senha do estudante"),
    writeln("Insira nova senha:"),
    read(NovaSenha),
    tty_clear,
    editar_senha_estudante(Matricula, NovaSenha, R),
    writeln(R), 
    opcoes_menu_estudante,
    read(Opcao),
    opcao_escolhida_estudante(Opcao, Matricula).

opcao_escolhida_estudante(2, Matricula) :- 
    writeln("Cadastrar voto de estudante"),
    writeln("Insira nova senha:"),
    read(NovaSenha),
    tty_clear,
    editar_senha_estudante(Matricula, NovaSenha, R),
    writeln(R), 
    opcoes_menu_estudante,
    read(Opcao),
    opcao_escolhida_estudante(Opcao, Matricula).

opcao_escolhida_estudante(3, _) :- 
    tty_clear,
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).

%Opcoes do cadastro votacao

opcao_escolhida_votacao(1):-
    writeln("Cadastrar estudante em chapa"),
    writeln("Insira matricula do estudante:"),
    read(Matricula),
    writeln("Insira id da chapa:"),
    read(Id_chapa),
    tty_clear,
    cadastrar_estudante_chapa(Matricula, Id_chapa, R),
    writeln(R), 
    opcao_menu_cadastro_votacao(),
    read(Opcao),
    opcao_escolhida_votacao(Opcao).

opcao_escolhida_votacao(3) :- 
    tty_clear,
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).  