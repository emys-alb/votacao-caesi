module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController
import Controllers.EstudanteController

main :: IO()
main = do
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
    
    putStrLn "O primeiro admin tem login e senha: admin"
    cadastrarAdmin conn "admin" "admin"
    cadastroNovosEstudantes conn
    editarSenhaEstudante conn
    
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