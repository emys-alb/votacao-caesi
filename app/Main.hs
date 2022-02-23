module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController


main :: IO()
main = do
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
    
    putStrLn "O primeiro admin tem login e senha: admin"
    --cadastraAdmin conn "" "" "admin" "admin"

    -- putStrLn "Cadastro de novo administrador"
    
    -- putStrLn "Coloque seu login como administrador"
    -- loginAdmin <- getLine
    -- putStrLn "Coloque sua senha como administrador"
    -- senhaAdmin <- getLine 
    -- putStrLn "Coloque o login do administrador"
    -- loginNovoAdmin <- getLine 
    -- putStrLn "Coloque a senha do administrador"
    -- senhaNovoAdmin <- getLine 
    
    -- cadastraAdmin conn loginAdmin senhaAdmin loginNovoAdmin senhaNovoAdmin

    putStrLn "Atualiza senha do administrador"

    putStrLn "Insira seu login como administrador:"
    loginAdmin <- getLine
    putStrLn "Insira a senha atual:"
    senhaAdmin <- getLine 
    putStrLn "Insira a nova senha:"
    novaSenhaAdmin <- getLine 
    editaSenhaAdmin conn loginAdmin senhaAdmin novaSenhaAdmin