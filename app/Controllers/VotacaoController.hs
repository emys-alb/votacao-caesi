module Controllers.VotacaoController where
import Database.PostgreSQL.Simple
import Models.Votacao

cadastraVotacao :: Connection -> String -> IO()
cadastraVotacao conn dataVotacao = do
    novaVotacao conn dataVotacao False 0 0
    return ()

encerraVotacao :: Connection -> Int -> IO()
encerraVotacao conn idVotacao = do
    encerra conn idVotacao
    return ()
