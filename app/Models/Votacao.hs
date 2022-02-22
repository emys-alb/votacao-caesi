{-# LANGUAGE OverloadedStrings #-}
module Models.Votacao where
import Database.PostgreSQL.Simple

data Votacao = Votacao {
    id :: Int,
    dataVotacao:: String,
    encerrada:: Bool,
    abstencoes:: Int,
    nulos:: Int
 } deriving (Show, Read, Eq)

novaVotacao :: Connection -> String -> Bool -> Int -> Int -> IO()
novaVotacao conn dataVotacao encerrada abstencoes nulos = do
    let comando = "INSERT INTO votacao (data,\
                                       \encerrada,\
                                       \abstencoes,\
                                       \nulos) VALUES (?, ?, ?, ?)"
    execute conn comando (dataVotacao, encerrada, abstencoes, nulos)
    return ()


encerra :: Connection -> Int -> IO()
encerra conn idVotacao = do
    let comando = "UPDATE votacao SET encerrada = 't' WHERE id = ?;"
    execute conn comando (Only (idVotacao :: Int))
    return ()