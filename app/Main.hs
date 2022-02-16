module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController


main :: IO()
main = do
    putStrLn "Criando base de dados..."
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
    cadastrarAdmin conn "admin" "senha123"