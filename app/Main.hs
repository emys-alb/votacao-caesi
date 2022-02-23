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
    \\n 3 - Cadastra novo estudante\
    \\n 4 - Edita senha do admininstrador"

    inputOpcao <- getLine
    menu inputOpcao conn


menu :: String -> Connection -> IO ()
menu opcao conn
    | opcao == "1" = cadastroPrimeiroAdmin conn
    | opcao == "2" = cadastroNovoAdmin conn
    | opcao == "3" = cadastroNovosEstudantes conn
    | opcao == "4" = editaSenhaAdmins conn

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

editaSenhaAdmins :: Connection -> IO()
editaSenhaAdmins conn = do
    putStrLn "Atualiza senha do administrador"

    putStrLn "Insira seu login como administrador:"
    loginAdmin <- getLine
    putStrLn "Insira a senha atual:"
    senhaAdmin <- getLine 
    putStrLn "Insira a nova senha:"
    novaSenhaAdmin <- getLine 
    editaSenhaAdmin conn loginAdmin senhaAdmin novaSenhaAdmin
