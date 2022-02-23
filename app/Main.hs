module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController
import Controllers.EstudanteController
import Models.Estudante (Estudante(matricula))

main :: IO()
main = do
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
    
    putStrLn "O primeiro admin tem login e senha: admin"
    --cadastrarAdmin conn "admin" "admin"
    --cadastroNovosEstudantes conn
    desativaEstudante conn

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

desativaEstudante :: Connection -> IO()
desativaEstudante conn = do
    putStrLn "Desativação de estudante"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a matrícula do estudante a ser desativado"
    matricula <- getLine
    --adicionar aqui o metodo de verificarAdmin
    desativarEstudante conn matricula