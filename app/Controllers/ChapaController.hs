module Controllers.ChapaController where


import Models.Votacao
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple (Connection, execute)
cadastrarChapa :: Connection -> String -> Int -> Int -> Int-> IO ()
--verificar se existe um admin (tlvez)
--permitir insert 
--
cadastrarChapa conn nomeChapa numeroChapa getIdVotacaoChapa(data) numDeVotosChapa = do 
    let i = "INSERT INTO chapa(nomeChapa,\numeroChapa,\getIdVotacao,\numDeVotosChapa) values (?,?,?,?)"
    execute conn i (getAdimin,nomeChapa,numeroChapa,getIdVotacao,numDeVotosChapa)
    return()
