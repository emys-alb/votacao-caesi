module Controllers.ChapaController where

import Database.PostgreSQL.Simple
import Models.Chapa

adicionaVotoChapa :: Connection -> Int -> IO ()
adicionaVotoChapa conn idChapa = do
  adicionaVoto conn idChapa

getChapas :: Connection -> IO [ChapaVisualization]
getChapas = getChapasVotacaoAtiva