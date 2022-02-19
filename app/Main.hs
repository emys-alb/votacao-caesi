module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController
import Controllers.EstudanteController

main :: IO()
main = do
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
    
    -- putStrLn "O primeiro admin tem login e senha: admin"
    -- cadastrarAdmin conn "admin" "admin"

    print "Digite o file path"
    filePath <- getLine
    cadastraEstudantes conn filePath