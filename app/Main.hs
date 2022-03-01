module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController
import Controllers.EstudanteController
import Controllers.VotacaoController
import Controllers.ChapaController
import Models.Estudante (Estudante(matricula))

mostraOpcoes :: Connection -> IO()
mostraOpcoes conn = do
    putStrLn "Menu de atividades: \
    \\n 1 - Cadastra o primeiro admin\
    \\n 2 - Cadastra novo administrador\
    \\n 3 - Remove administrador\
    \\n 4 - Edita senha do administrador\
    \\n 5 - Cadastra estudantes\
    \\n 6 - Edita senha do estudante\
    \\n 7 - Desativa estudante\
    \\n 8 - Cadastra votação\
    \\n 9 - Cadastra chapa\
    \\n 10 - Cadastra estudante em chapa\
    \\n 11 - Edita chapa\
    \\n 12 - Remove chapa\
    \\n 13 - Cadastra voto de estudante\
    \\n 14 - Lista dados da votação\
    \\n 15 - Lista histórico de votações\
    \\n 16 - Compara votações\
    \\n 17 - Sair"

    inputOpcao <- getLine
    if inputOpcao /= "17" then do
        menu inputOpcao conn
        mostraOpcoes conn
    else
        putStrLn "Fechando sistema"

main :: IO()
main = do
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"

    mostraOpcoes conn


menu :: String -> Connection -> IO ()
menu opcao conn
    | opcao == "1" = cadastroPrimeiroAdmin conn
    | opcao == "2" = cadastroNovoAdmin conn
    | opcao == "5" = cadastroNovosEstudantes conn
    | opcao == "6" = editarSenhaEstudante conn
    | opcao == "7" = desativaEstudante conn
    | opcao == "8" = cadastroVotacao conn
    | opcao == "10" = cadastroEstudanteChapa conn
    | otherwise = putStrLn "Opção inválida"

cadastroPrimeiroAdmin :: Connection -> IO()
cadastroPrimeiroAdmin conn = do
    putStrLn "O primeiro admin tem login e senha: admin"
    cadastraAdmin conn "" "" "admin" "admin"

cadastroNovoAdmin :: Connection -> IO()
cadastroNovoAdmin conn = do
    putStrLn "Cadastro de novo administrador"

    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira o login do novo administrador"
    loginNovoAdmin <- getLine
    putStrLn "Insira a senha do novo administrador"
    senhaNovoAdmin <- getLine

    cadastraAdmin conn loginAdmin senhaAdmin loginNovoAdmin senhaNovoAdmin

cadastroNovosEstudantes :: Connection -> IO()
cadastroNovosEstudantes conn = do
    putStrLn "Cadastro de novos estudantes"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira o caminho para o arquivo .csv que deve conter duas colunas (matricula e senha) para cada estudante"
    caminho <- getLine
    cadastraEstudantes conn loginAdmin senhaAdmin caminho

desativaEstudante :: Connection -> IO()
desativaEstudante conn = do
    putStrLn "Desativação de estudante"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a matrícula do estudante a ser desativado"
    matricula <- getLine
    desativarEstudante conn loginAdmin senhaAdmin matricula
editarSenhaEstudante :: Connection -> IO()
editarSenhaEstudante conn = do
    putStrLn "Editar senha do estudante"
    putStrLn "Insira sua matrícula"
    matricula <- getLine
    putStrLn "Insira sua senha atual"
    senhaAtual <- getLine
    putStrLn "Insira sua nova senha"
    novaSenha <- getLine
    editaSenha conn matricula senhaAtual novaSenha

cadastroVotacao :: Connection -> IO()
cadastroVotacao conn = do
    putStrLn "Cadastrar uma nova votação"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a data da nova votação"
    dataVotacao <- getLine

    cadastraVotacao conn loginAdmin senhaAdmin dataVotacao

cadastroEstudanteChapa :: Connection -> IO ()
cadastroEstudanteChapa conn = do
    putStrLn "Cadastro de estudante em chapa"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a matricula do estudante"
    matricula <- getLine
    putStrLn "Insira o id da chapa"
    idChapa <- getLine
    putStrLn "Insira a diretoria do estudante candidato"
    diretoria <- getLine

    cadastraEstudanteEmChapa conn loginAdmin senhaAdmin matricula (read idChapa) diretoria
