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

    putStrLn "Coloque seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Coloque sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Coloque o login do administrador"
    loginNovoAdmin <- getLine
    putStrLn "Coloque a senha do administrador"
    senhaNovoAdmin <- getLine

    cadastraAdmin conn loginAdmin senhaAdmin loginNovoAdmin senhaNovoAdmin