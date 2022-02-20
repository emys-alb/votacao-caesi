module Controllers.VotacaoController where
import Database.PostgreSQL.Simple
import Models.Votacao

cadastraVotacao :: Connection -> String -> IO()
cadastraVotacao conn dataVotacao =
    novaVotacao conn dataVotacao
    return ()
