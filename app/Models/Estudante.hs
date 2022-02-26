{-# LANGUAGE OverloadedStrings #-}
module Models.Estudante where

import Database.PostgreSQL.Simple
import Control.Exception
import Data.Int
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

cadastraEstudante :: Connection -> String -> String -> IO()
cadastraEstudante conn matricula senha = do
    print ("cadastrando estudante de matricula " ++ matricula)
    let q = "insert into estudante (matricula,\
                \senha, votante) values (?,?,?)"
    result <- try (execute conn q (matricula, senha, True)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> putStrLn "Estudante cadastrado"
        
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


cadastrarVoto :: Connection -> String -> String -> Int -> Int -> IO()
cadastrarVoto conn matricula senha idVotacao numChapa = do
    let q = "update  set senha = ? \
            \where matricula = ? and senha = ?"
    result <- try (execute conn q (novaSenha, matricula, senhaAtual)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> putStrLn "Senha atualizada"

    return ()