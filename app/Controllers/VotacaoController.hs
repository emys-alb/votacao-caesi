module Controllers.VotacaoController where
import Database.PostgreSQL.Simple
import Control.Exception
import Models.Votacao

cadastraVotacao :: Connection -> String -> String -> String -> IO()
cadastraVotacao conn loginAdmin senhaAdmin dataVotacao = do
    result <- try (novaVotacao conn loginAdmin senhaAdmin dataVotacao False 0 0) :: IO (Either SomeException ())
    case result of
        Left err -> putStrLn $ "Caught exception: " ++ show err
        Right val -> print "Votacao cadastrada"
    return ()
