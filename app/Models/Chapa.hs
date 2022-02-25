{-# LANGUAGE OverloadedStrings #-}

module Models.Chapa where

import Control.Exception (SomeException (SomeException), catch, try)
import Data.Int
import Database.PostgreSQL.Simple
import Models.Admin

data Chapa = Chapa
  { nome :: String,
    numero :: Int,
    idVotacao :: Int, --precisa implementar isso
    numDeVotos :: Int --precisa ver se é necessario
  }
  deriving (Show, Read, Eq)

cadastrarChapa :: Connection -> String -> String -> String -> Int -> Int -> IO ()
cadastrarChapa conn loginAdmin senhaAdmin nomeChapa numeroChapa idVotacaoChapa = do
  let i = "INSERT INTO chapa(nome,numero,idVotacao,numDeVotos) values (?,?,?,?)"
  admin <- getAdmin conn loginAdmin senhaAdmin
  --idVotacao <-
  let inicia = 0
  if (admin /= [])
    then do
      cadastroChapa <- try (execute conn i (nomeChapa, numeroChapa, idVotacaoChapa, inicia :: Int)) :: IO (Either SomeException Int64)
      case cadastroChapa of
        Left err -> putStrLn $ "Caught exception: " ++ show err
        Right val -> print "Chapa cadastrada"
    else error "Erro no cadastro Chapa: Administrador não está cadastrado no sistema"

  return ()
