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
    writeln("[1] Cadastra chapa"),
    writeln("[2] Adiciona estudante na chapa"),
    writeln("[3] Encerrar cadastro de votação\n").
opcao_menu_edita_votacao() :-
    writeln("MENU Votação"),
    writeln("[1] Cadastra chapa"),
    writeln("[2] Edita informações da chapa"),
    writeln("[3] Remove chapa"),
    writeln("[4] Adiciona estudante na chapa"),
    writeln("[5] Remove estudante na chapa"),
    writeln("[6] Voltar\n").

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

opcao_escolhida_principal(3) :-
    writeln("Dados de uma votação"),
    writeln("Insira o ID da votação buscada:"),
    read(IDVotacao),
    (verifica_votacao_ativa(IDVotacao) ->
        (tty_clear,
        writeln("Votação ainda não foi encerrada."));
        (
            get_dados_votacao(IDVotacao, Result),
            tty_clear,
            (eh_vazia(Result) ->
            writeln("Votação não encontrada");
            imprimeEleicoes(Result))
        )
    ),
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).

imprimeEleicoes([]).

imprimeEleicoes([row(IDVotacao, DataVotacao, _, Abstencoes, Nulos) | T]) :-
    writeln(""),
    write("ID: "), writeln(IDVotacao),
    write("Data da votação: "), writeln(DataVotacao),
    write("Abstencoes: "), writeln(Abstencoes),
    write("Nulos: "), writeln(Nulos),
    (get_chapa_vencedora(IDVotacao, row(IDChapa, Nome, Num, IDVotacao, NumVotos)) ->
        (write("Chapa Vencedora:"), writeln(Nome),
        write("Quantidade de votos:"), writeln(NumVotos));
        writeln("")
    ),
    writeln("-----"),
    imprimeEleicoes(T).

opcao_escolhida_principal(4) :-
    tty_clear,
    writeln("Histórico de votações"),
    get_votacoes_encerradas(Result),
    imprimeEleicoes(Result),
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).

opcao_escolhida_principal(5) :-
    tty_clear,
    writeln("Comparação de eleições"),
    writeln("Insira o ID da primeira votação:"),
    read(IDVotacao1),
    writeln("Insira o ID da segunda votação:"),
    read(IDVotacao2),
    get_dados_votacao(IDVotacao1, Votacao1),
    get_dados_votacao(IDVotacao2, Votacao2),
    (eh_vazia(Votacao1) ->
        writeln("Primeira votação não encontrada");
        imprimeEleicoes(Votacao1)
    ),
    (eh_vazia(Votacao2) ->
        writeln("Segunda votação não encontrada");
        imprimeEleicoes(Votacao2)
    ),
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).

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
    cadastro_votacao(DataVotacao, IdVotacao, R),
    tty_clear,
    writeln(R),
    opcao_menu_cadastro_votacao(),
    read(Opcao),
    opcao_escolhida_votacao(Opcao, IdVotacao).

opcao_escolhida_admin(7) :-
    writeln("Edita Votação"),
    writeln("Insira o ID da votação que deseja editar:"),
    read(IdVotacao),
    opcao_menu_edita_votacao(),
    read(Opcao),
    opcao_escolhida_edita_votacao(Opcao, IdVotacao, R),
    tty_clear,
    writeln(R),
    opcoes_menu_admin,
    read(Opcao2),
    opcao_escolhida_admin(Opcao2).

opcao_escolhida_admin(8) :-
    writeln("Encerrar votação"),
    writeln("Insira o id da votação que deseja encerrar:"),
    read(IdVotacao),
    get_quantidade_estudantes_votantes(Votantes),
    get_votos_chapas_votacao(IdVotacao, VotosChapas),
    encerra_votacao(IdVotacao, Votantes, VotosChapas, R),
    tty_clear,
    writeln(R),
    get_quantidade_estudantes_votantes(Qtd),
    writeln(Qtd),
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

opcao_escolhida_estudante(1, Matricula) :- 
    writeln("Cadastrar voto de estudante"),
    writeln("Insira nova senha:"),
    read(NovaSenha),
    tty_clear,
    editar_senha_estudante(Matricula, NovaSenha, R),
    writeln(R),
    opcoes_menu_estudante,
    read(Opcao),
    opcao_escolhida_estudante(Opcao, Matricula).

opcao_escolhida_estudante(2, Matricula) :-
    (eh_votante(Matricula) ->
        (writeln("Cadastrar voto de estudante"),
        get_chapas_votacoes_ativas(Chapas),
        print_chapas(Chapas),
        writeln("Insira o ID da votação:"),
        read(IdVotacao),
        (verifica_votacao_ativa(IdVotacao) ->
            (voto_cadastrado(Matricula, IdVotacao) -> 
                (tty_clear, writeln("Voto já cadastrado nessa votação"));
                writeln("Insira o número da chapa: (se o seu voto for nulo, digite 'n')"),
                read(ChapaNum),
                tty_clear,
                cadastra_voto(ChapaNum, Matricula, IdVotacao)
            );
            tty_clear,writeln("Votação encerrada ou inexistente")
        )
        );
        tty_clear,writeln("Estudante não é votante")    
    ),
    opcoes_menu_estudante,
    read(Opcao),
    opcao_escolhida_estudante(Opcao, Matricula).

cadastra_voto('n', Matricula, IdVotacao) :-
    cadastra_voto_estudante(Matricula, IdVotacao),
    adiciona_voto_nulo_votacao(IdVotacao),
    writeln("Voto Cadastrado").
cadastra_voto(ChapaNum, Matricula, IdVotacao) :- 
    (verifica_chapa_by_numero_e_votacao(ChapaNum, IdVotacao) ->
        (
            cadastra_voto_estudante(Matricula, IdVotacao),
            adiciona_voto_chapa(ChapaNum, IdVotacao),
            writeln("Voto Cadastrado")
        );
        writeln("Chapa não encontrada")
    ).

print_chapas([]).
print_chapas([row(Id,Nome,Numero,IdVotacao,_)|T]) :- 
    format("Votacao ID ~q: ~q, ID ~q, número ~q\n", [IdVotacao, Nome, Id, Numero]),
    print_chapas(T).

opcao_escolhida_estudante(3, _) :- 
    tty_clear,
    opcoes_menu_principal,
    read(Opcao),
    opcao_escolhida_principal(Opcao).

%Opcoes do cadastro votacao

opcao_escolhida_votacao(1, IdVotacao) :- 
    writeln("Cadastro Chapa"),
    writeln("Insira o nome da Chapa"),
    read(Nome),
    writeln("Insira o número da Chapa"),
    read(Numero),
    (verifica_by_numero_votacao(Numero,IdVotacao) -> 
        (tty_clear,format("Chapa de numero ~q já cadastrada nessa votação\n", [Numero]));
        cadastra_chapa(Nome,Numero,IdVotacao,R)
    ),
    opcao_menu_cadastro_votacao(),
    read(Opcao),
    opcao_escolhida_votacao(Opcao, IdVotacao).  

opcao_escolhida_votacao(2, _):-
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
    opcao_escolhida_votacao(Opcao, IdVotacao).


opcao_escolhida_votacao(3, _) :- 
    tty_clear,
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).  

opcao_escolhida_edita_votacao(1, IdVotacao, _) :-
    opcao_escolhida_votacao(1, IdVotacao).

opcao_escolhida_edita_votacao(2, IdVotacao, R) :-
    writeln("Insira o id da chapa que deseja editar:"),
    read(IdChapa),
    writeln("MENU Edita Chapa"),
    writeln("[1] Edita nome da chapa"),
    writeln("[2] Edita número da chapa"),
    read(Opcao),
    (Opcao =:= 1 -> 
        writeln("Insira o novo nome da chapa:"),
        (read(Nome),
        edita_nome_chapa(IdChapa, Nome, R));
        writeln("Insira o novo número da chapa:"),
        read(Numero),
        edita_numero_chapa(IdChapa, Numero, R)
    ).

opcao_escolhida_edita_votacao(3, _, _):-
    writeln("Remove chapa"),
    writeln("Insira id da chapa:"),
    read(Id),
    tty_clear,
    remover_chapa(Id,R),
    writeln(R), 
    opcao_menu_edita_votacao(),
    read(Opcao),
    opcao_escolhida_edita_votacao(Opcao, _, _).

opcao_escolhida_edita_votacao(4, IdVotacao, _) :-
    opcao_escolhida_votacao(2, _).

opcao_escolhida_edita_votacao(5, _, _):-
    writeln("Remove estudante de chapa"),
    writeln("Insira matricula do estudante:"),
    read(Matricula),
    writeln("Insira id da chapa:"),
    read(Id_chapa),
    tty_clear,
    remover_estudante_chapa(Matricula, Id_chapa, R),
    writeln(R), 
    opcao_menu_edita_votacao(),
    read(Opcao),
    opcao_escolhida_edita_votacao(Opcao, _, _).

opcao_escolhida_edita_votacao(6, _, _) :- 
    tty_clear,
    opcoes_menu_admin,
    read(Opcao),
    opcao_escolhida_admin(Opcao).
