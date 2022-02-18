{-# LANGUAGE OverloadedStrings #-}
module Models.Estudante where

import Database.PostgreSQL.Simple

data Estudante = Estudante {
    matricula:: String,
    senha:: String,
    votante:: Bool
} deriving (Show, Read, Eq)

cadastraEstudante :: Connection -> String -> String -> IO()
cadastraEstudante conn matricula senha = do
    let q = "insert into estudante (matricula,\
                \senha, votante) values (?,?,?)"
    execute conn q (matricula, senha, True)
    return ()
 