{-# LANGUAGE OverloadedStrings #-}
module Models.Estudante where

import Database.PostgreSQL.Simple
import Control.Exception (catch, try, SomeException (SomeException))
import Data.Int
import Data.Bool (bool)
import Text.Read (Lexeme(String))

data Estudante = Estudante {
    matricula:: String,
    senha:: String,
    votante:: Bool
} deriving (Show, Read, Eq)

cadastraEstudante :: Connection -> String -> String -> IO()
cadastraEstudante conn matricula senha = do
    print ("cadastrando estudante de matricula " ++ matricula)
    let q = "insert into estudante (matricula,\
                \senha, votante) values (?,?,?)"
    result <- try (execute conn q (matricula, senha, True)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> print "Estudante cadastrado"
        
desativaEstudante :: Connection -> String -> IO()
desativaEstudante conn matricula = do
    print ("Desativando estudante de matricula " ++ matricula)
    let q = "update estudante set votante=? \
            \where estudante.matricula=?"
    result <- try (execute conn q (False :: Bool, matricula :: String)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> print "Estudante desativado"