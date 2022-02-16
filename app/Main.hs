module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController


main :: IO()
main = do
    putStrLn "Criando base de dados..."
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
    
    putStrLn "O primeiro admin tem login e senha: admin"
    cadastrarAdmin conn "admin" "admin"
    putStrLn "Cadastro com sucesso!"