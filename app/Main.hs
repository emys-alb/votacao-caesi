module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController


main :: IO()
main = do
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"

    putStrLn "Menu de ativades: \
    \\n 1 - Cadastra o primeiro admin\
    \\n 2 - Cadastra novo administrador"

    inputOpcao <- getLine
    menu inputOpcao conn


menu :: String -> Connection -> IO ()
menu opcao conn
    | opcao == "1" = cadastroPrimeiroAdmin conn
    | opcao == "2" = cadastroNovoAdmin conn

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