module Models.Chapa where

import Models.Admin

data Chapa = Chapa
  { nomeChapa :: String,
    numeroChapa :: Int,
    idVotacaoChapa :: Int --precisa implementar isso
    numDeVotosChapa :: Int --precisa ver se é necessario
  }
  deriving (Show, Read, Eq)
