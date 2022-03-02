module Controllers.VotacaoController where
import Database.PostgreSQL.Simple
import Control.Exception
import Models.Votacao

encerraVotacao :: Connection -> Int -> IO()
encerraVotacao conn idVotacao = do
    encerra conn idVotacao

cadastraVotacao :: Connection -> String -> String -> String -> IO()
cadastraVotacao conn loginAdmin senhaAdmin dataVotacao = do
    result <- try (novaVotacao conn loginAdmin senhaAdmin dataVotacao False 0 0) :: IO (Either SomeException ())
    case result of
        Left err -> putStrLn $ "Caught exception: " ++ show err
        Right val -> print "Votacao cadastrada"
    return ()

comparaVotacao :: Connection -> Int -> Int -> IO [Votacao]
comparaVotacao conn idPrimeira idSegunda = do
    comparacao conn idPrimeira idSegunda

adicionaVotosNulo :: Connection -> Int -> IO ()
adicionaVotosNulo conn idVotacao = do
    adicionaVotoNulo conn idVotacao
    
    return ()
