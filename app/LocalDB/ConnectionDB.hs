{-# LANGUAGE OverloadedStrings #-}

module LocalDB.ConnectionDB where

import Control.Exception
import Data.Int
import Database.PostgreSQL.Simple

localDB :: ConnectInfo
localDB =
  defaultConnectInfo
    { connectHost = "ec2-54-235-108-217.compute-1.amazonaws.com",
      connectDatabase = "dbehln4jerq4b",
      connectUser = "jzrhucvekfwaal",
      connectPassword = "fc13fbfff03b8b15a7186f8cabf894bcb3bacee463dd080a803690d72658217d",
      connectPort = 5432
    }

connectionMyDB :: IO Connection
connectionMyDB = connect localDB

createAdmin :: Connection -> IO ()
createAdmin conn = do
  execute_
    conn
    "CREATE TABLE IF NOT EXISTS admin (\
    \login VARCHAR(20) PRIMARY KEY,\
    \senha VARCHAR(15) NOT NULL);"
  return ()

createEstudante :: Connection -> IO ()
createEstudante conn = do
  execute_
    conn
    "CREATE TABLE IF NOT EXISTS estudante (\
    \matricula VARCHAR(50) PRIMARY KEY,\
    \senha VARCHAR(15) NOT NULL,\
    \votante BOOLEAN NOT NULL);"
  return ()

createVotacao :: Connection -> IO ()
createVotacao conn = do
  execute_
    conn
    "CREATE TABLE IF NOT EXISTS votacao (\
    \id SERIAL PRIMARY KEY,\
    \data VARCHAR(15) NOT NULL,\
    \encerrada BOOLEAN NOT NULL,\
    \abstencoes INTEGER,\
    \nulos INTEGER);"
  return ()

createChapa :: Connection -> IO ()
createChapa conn = do
  execute_
    conn
    "CREATE TABLE IF NOT EXISTS chapa (\
    \id SERIAL PRIMARY KEY,\
    \nome VARCHAR(50) NOT NULL,\
    \numero INTEGER NOT NULL,\
    \idVotacao INTEGER NOT NULL,\
    \numDeVotos INTEGER NOT NULL,\
    \FOREIGN KEY (idVotacao) REFERENCES votacao (id));"
  return ()

createEstudanteChapa :: Connection -> IO ()
createEstudanteChapa conn = do
  execute_
    conn
    "CREATE TABLE IF NOT EXISTS estudante_chapa (\
    \id SERIAL PRIMARY KEY,\
    \idEstudante VARCHAR(50) NOT NULL,\
    \idChapa INTEGER NOT NULL,\
    \idVotacao INTEGER NOT NULL,\
    \diretoria VARCHAR(50) NOT NULL,\
    \FOREIGN KEY (idEstudante) REFERENCES estudante (matricula),\
    \FOREIGN KEY (idVotacao) REFERENCES votacao (id),\
    \FOREIGN KEY (idChapa) REFERENCES chapa (id));"
  return ()

createVoto :: Connection -> IO ()
createVoto conn = do
  execute_
    conn
    "CREATE TABLE IF NOT EXISTS voto (\
    \id SERIAL PRIMARY KEY,\
    \idEstudante VARCHAR(50) NOT NULL,\
    \idVotacao INTEGER NOT NULL,\
    \FOREIGN KEY (idEstudante) REFERENCES estudante (matricula),\
    \FOREIGN KEY (idVotacao) REFERENCES votacao (id));"
  return ()

adicionaConstraintChapa :: Connection -> IO ()
adicionaConstraintChapa conn = do
  result <-
    try
      ( execute_
          conn
          "ALTER TABLE chapa ADD CONSTRAINT chapa_numero_idvotacao_key \
          \UNIQUE (numero, idVotacao);"
      ) ::
      IO (Either SqlError Int64)
  case result of
    Left err -> putStrLn $ "NOTICE: " ++ show (sqlErrorMsg err)
    Right val -> putStrLn "Constraint added"
  return ()

iniciandoDatabase :: IO Connection
iniciandoDatabase = do
  c <- connectionMyDB
  createAdmin c
  createEstudante c
  createVotacao c
  createChapa c
  createEstudanteChapa c
  createVoto c
  adicionaConstraintChapa c
  return c