{-# LANGUAGE OverloadedStrings #-}
module Models.Estudante where

import Database.PostgreSQL.Simple
import Control.Exception
import Data.Int
import Data.Bool (bool)
import Text.Read (Lexeme(String))
import Database.PostgreSQL.Simple.FromRow

data Estudante = Estudante {
    matricula:: String,
    senha:: String,
    votante:: Bool
} deriving (Show, Read, Eq)

instance FromRow Estudante where
    fromRow = Estudante <$> field
                        <*> field
                        <*> field

data Voto = Voto {
    id:: Int,
    idEstudante:: String,
    idVotacao:: Int
} deriving (Show, Read, Eq)

instance FromRow Voto where
    fromRow = Voto <$> field
                        <*> field
                        <*> field


cadastraEstudante :: Connection -> String -> String -> IO()
cadastraEstudante conn matricula senha = do
    print ("cadastrando estudante de matricula " ++ matricula)
    let q = "insert into estudante (matricula,\
                \senha, votante) values (?,?,?)"
    result <- try (execute conn q (matricula, senha, True)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> putStrLn "Estudante cadastrado"
        
desativaEstudante :: Connection -> String -> IO()
desativaEstudante conn matricula = do
    putStrLn ("Desativando estudante de matricula " ++ matricula)
    let q = "update estudante set votante=? \
            \where estudante.matricula=?"
    result <- try (execute conn q (False :: Bool, matricula :: String)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> if val == 0 then putStrLn "Estudante inexistente" else putStrLn "Estudante desativado"
        
editaSenhaEstudante :: Connection -> String -> String -> String -> IO()
editaSenhaEstudante conn matricula senhaAtual novaSenha = do
    let q = "update estudante set senha = ? \
            \where matricula = ? and senha = ?"
    result <- try (execute conn q (novaSenha, matricula, senhaAtual)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> putStrLn "Senha atualizada"

    return ()

getEstudante :: Connection -> String -> String -> IO [Estudante]
getEstudante conn matricula senha = do
    let q = "select * from estudante where matricula = ? and senha = ?"
    query conn q (matricula::String, senha::String) :: IO[Estudante]

criaRelacaoEstudanteVotacao :: Connection -> String -> Int -> IO ()
criaRelacaoEstudanteVotacao conn matricula idVotacao = do
    let q = "insert into voto (idEstudante,\
                \idVotacao) values (?,?)"
    result <- try (execute conn q (matricula, idVotacao)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> putStrLn "Voto cadastrado"

    return ()

isEstudanteVotante :: Connection -> String -> String -> IO Bool
isEstudanteVotante conn matricula senha = do
    info <- try (getEstudante conn matricula senha) :: IO (Either SomeException [Estudante])
    case info of
        Left e -> do 
            putStrLn $ "Caught exception: " ++ show e
            return False
        Right estudanteList -> do
            return (not (null estudanteList) && votante (head estudanteList))


verificaEstudanteNaoVotou :: Connection -> String -> Int -> IO Bool
verificaEstudanteNaoVotou conn idEstudante idVotacao = do
    let comando = "SELECT * FROM voto WHERE idEstudante = ? and idVotacao = ?"

    listaVotos <- query conn comando (idEstudante :: String, idVotacao :: Int) :: IO [Voto]

    return (null listaVotos)
