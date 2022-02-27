{-# LANGUAGE OverloadedStrings #-}

module Models.Chapa where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Control.Exception
import Data.Int

data Chapa = Chapa
  { nome :: String,
    numero :: Int,
    idVotacao :: Int,
    numDeVotos :: Int
  }
  deriving (Show, Read, Eq)

instance FromRow Chapa where
    fromRow = Chapa <$> field
                      <*> field
                      <*> field
                      <*> field


data ChapaVisualization = ChapaVisualization
  { nomeChapa :: String,
    numeroChapa :: Int
  }
  deriving (Show, Read, Eq)

instance FromRow ChapaVisualization where
    fromRow = ChapaVisualization <$> field
                      <*> field

getChapasVotacaoAtiva :: Connection -> IO [ChapaVisualization]
getChapasVotacaoAtiva conn = do
    let q = "select c.nome, c.numero from chapa as c, votacao as v where c.idVotacao=v.id and v.encerrada=false"

    query_ conn q :: IO [ChapaVisualization]
    -- case result of
    --     Left err  -> putStrLn $ "Caught exception: " ++ show err
    --     Right val -> if val == 0 then putStrLn "Chapa não encontrada" else putStrLn "Numero de votos atualizado"
    

adicionaVoto :: Connection -> Int -> IO ()
adicionaVoto conn id = do
    let q = "update chapa set numDeVotos = numDeVotos + 1 \
            \where id = ?"
    result <- try (execute conn q (Only (id :: Int))) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> if val == 0 then putStrLn "Chapa não encontrada" else putStrLn "Numero de votos atualizado"
    
    return ()