{-# LANGUAGE OverloadedStrings #-}

module Models.Chapa where

import Control.Exception
import Data.Int
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow

data Chapa = Chapa
  {
    chapaId :: Int,
    nome :: String,
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
                      <*> field


data EstudanteChapa = EstudanteChapa
  {
    id :: Int,
    idEstudante :: String,
    idChapa :: Int,
    votacaoId :: Int,
    diretoria :: String
  }
  deriving (Show, Read, Eq)

instance FromRow EstudanteChapa where
    fromRow = EstudanteChapa <$> field
                      <*> field
                      <*> field
                      <*> field
                      <*> field

cadastraEstudanteChapa :: Connection -> String -> Int -> Int -> String -> IO()
cadastraEstudanteChapa conn matricula idChapa idVotacao diretoria = do
  resultado <- verificaEstudanteJaCandidatoNaVotacao conn matricula idVotacao
  if null resultado then do
    let q = "insert into estudante_chapa (idEstudante, idChapa,\
            \idVotacao, diretoria) values (?,?,?,?)"
    result <- try (execute conn q (matricula, idChapa, idVotacao, diretoria)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> putStrLn "Estudante cadastrado na chapa"
  else putStrLn "Estudante já é candidato nessa votação"

getChapaById :: Connection -> Int -> IO[Chapa]
getChapaById conn idChapa = do
  let q = "select * from chapa where id = ?"
  query conn q (Only idChapa) :: IO[Chapa]

verificaEstudanteJaCandidatoNaVotacao :: Connection -> String -> Int -> IO [EstudanteChapa]
verificaEstudanteJaCandidatoNaVotacao conn matricula idVotacao = do
  let q = "select * from estudante_chapa where idEstudante = ? and idVotacao = ?"
  query conn q (matricula, idVotacao) :: IO[EstudanteChapa]