module Controllers.ChapaController where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple (Connection, execute)
import Models.Admin
import Models.Chapa

--import Models.Votacao

cadastraChapa :: Connection -> String -> String -> String -> Int -> Int -> IO ()
cadastraChapa conn loginAdmin senhaAdmin nomeChapa numeroChapa idVotacaoChapa = do
  cadastrarChapa conn loginAdmin senhaAdmin nomeChapa numeroChapa idVotacaoChapa
