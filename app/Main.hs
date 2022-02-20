module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController
import Controllers.VotacaoController

main :: IO()
main = do
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
    
    -- putStrLn "O primeiro admin tem login e senha: admin"
    -- cadastrarAdmin conn "admin" "admin"

    -- Essa parte é o cadastro de votação que ainda precisa ser colocado em um menu, etc.
    -- O objetivo aqui é só testar e ter uma ideia de como vai funcionar
    print "Digite o login do admin:"
    loginAdmin <- getLine 
    print "Digite a senha do admin:"
    senhaAdmin <- getLine
    -- nesse ponto deve-se chamar uma funcao que verifique o login e senha do admin

    print "Digite a data da votação:"
    dataVotacao <- getLine

    cadastraVotacao conn dataVotacao
