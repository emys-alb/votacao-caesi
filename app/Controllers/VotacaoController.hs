module Controllers.VotacaoController where
import Database.PostgreSQL.Simple
import Control.Exception
import Models.Votacao
import Models.Chapa (getVotosChapasByVotacao, votacaoEmpatou)
import Models.Estudante (getQtdEstudantesVotantes)
import Controllers.ChapaController (getVotosEmChapas)
import Data.Int
import Models.Admin

encerraVotacao :: Connection -> String -> String -> Int -> IO()
encerraVotacao conn loginAdmin senhaAdmin idVotacao = do
    resultadoAdmin <- getAdmin conn loginAdmin senhaAdmin
    if resultadoAdmin /= []
        then do
            vt <- getVotacao conn idVotacao

            if null vt then putStrLn "Votação não encontrada"
            else do
                qtdVotantes <- getQtdEstudantesVotantes conn
                nulos <- getQtdVotosNulos conn idVotacao
                votosEmChapas <- getVotosEmChapas conn idVotacao
                let abst = qtdVotantes - nulos - votosEmChapas

                empatou <- votacaoEmpatou conn idVotacao

                encerra conn idVotacao abst empatou
    else
        putStrLn "Erro ao encerrar votacao: Administrador não está cadastrado no sistema"

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

getTotalVotosVotacao :: Connection -> Int -> IO Int
getTotalVotosVotacao conn id = do
    votosValidos <- getVotosChapasByVotacao conn id
    votosNulos <- getQtdVotosNulos conn id
    return (votosValidos + votosNulos)

listarTodasVotacoes :: Connection -> IO [Votacao]
listarTodasVotacoes conn = do
    getTodasVotacoes conn

votacaoEncerrada :: Connection -> Int -> IO Bool
votacaoEncerrada conn idVotacao  = do
    isVotacaoEncerrada conn idVotacao

getVotacao :: Connection -> Int -> IO [Votacao]
getVotacao = getVotacaoById
