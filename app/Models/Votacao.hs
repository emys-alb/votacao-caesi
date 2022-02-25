{-# LANGUAGE OverloadedStrings #-}
module Models.Votacao where
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.FromField
import Control.Exception
import Data.Int

data Votacao = Votacao {
    id :: Int,
    dataVotacao:: String,
    encerrada:: Bool,
    abstencoes:: Int,
    nulos:: Int
 } deriving (Show, Read, Eq)

instance FromRow Votacao where
    fromRow = Votacao <$> field
                      <*> field
                      <*> field
                      <*> field
                      <*> field

novaVotacao :: Connection -> String -> Bool -> Int -> Int -> IO()
novaVotacao conn dataVotacao encerrada abstencoes nulos = do
    let comando = "INSERT INTO votacao (data,\
                                       \encerrada,\
                                       \abstencoes,\
                                       \nulos) VALUES (?, ?, ?, ?)"

    result <- try (execute conn comando (dataVotacao, encerrada, abstencoes, nulos)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> print "Votacao cadastrada"
    return ()


encerra :: Connection -> Int -> IO()
encerra conn idVotacao = do
    let comando = "UPDATE votacao SET encerrada = 't' WHERE id = ?;"

    result <- try (execute conn comando (Only (idVotacao :: Int))) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> print "Votacao encerrada"
    return ()

getVotacaoById :: Connection -> Int -> IO [Votacao]
getVotacaoById conn idVotacao = do
    let comando = "SELECT * FROM votacao WHERE id = ?"

    query conn comando (Only (idVotacao :: Int)) :: IO [Votacao]