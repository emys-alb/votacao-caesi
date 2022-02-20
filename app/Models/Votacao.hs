{-# LANGUAGE OverloadedStrings #-}
module Models.Votacao where
import Database.PostgreSQL.Simple

data Votacao = Votacao (
    id :: Int,
    data:: String,
    encerrada:: Bool,
    abstencoes:: Int,
    nulos:: Int
) deriving (Show, Read, Eq)

novaVotacao :: Connection -> String -> IO()
novaVotacao conn dataVotacao =
    let comando = "INSERT INTO votacao (data,\
                                       \encerrada,\
                                       \abstencoes,\
                                       \nulos) VALUES (?, ?, ?, ?)"
    
    execute conn comando (dataVotacao, False, 0, 0)
    return ()