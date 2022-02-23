module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController
import Controllers.EstudanteController

main :: IO()
main = do
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"

    putStrLn "Menu de ativades: \
    \\n 1 - Cadastra o primeiro admin\
    \\n 2 - Cadastra novo administrador\
    \\n 3 - Remove administrador\
    \\n 4 - Cadastra estudantes\
    \\n 5 - Edita senha do estudante\
    \\n 6 - Desativa estudante\
    \\n 7 - Cadastra votação\
    \\n 8 - Cadastra chapa\
    \\n 9 - Edita chapa\
    \\n 10 - Remove chapa\
    \\n 11 - Cadastra voto de estudante\
    \\n 12 - Lista dados da votação\
    \\n 13 - Lista histórico de votações\
    \\n 14 - Compara votações"

    inputOpcao <- getLine
    menu inputOpcao conn


menu :: String -> Connection -> IO ()
menu opcao conn
    | opcao == "1" = cadastroPrimeiroAdmin conn
    | opcao == "2" = cadastroNovoAdmin conn
    | opcao == "3" = cadastroNovosEstudantes conn
    | opcao == "4" = editarSenhaEstudante conn

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
    --adicionar aqui o metodo de verificarAdmin
    cadastraEstudantes conn caminho

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