{-# LANGUAGE OverloadedStrings #-}
module Models.Votacao where
import Models.Admin
import Database.PostgreSQL.Simple
import Control.Exception
import Data.Int

data Votacao = Votacao {
    id :: Int,
    dataVotacao:: String,
    encerrada:: Bool,
    abstencoes:: Int,
    nulos:: Int
 } deriving (Show, Read, Eq)

novaVotacao :: Connection -> String -> String -> String -> Bool -> Int -> Int -> IO()
novaVotacao conn loginAdmin senhaAdmin dataVotacao encerrada abstencoes nulos = do
    let comando = "INSERT INTO votacao (data,\
                                       \encerrada,\
                                       \abstencoes,\
                                       \nulos) VALUES (?, ?, ?, ?)"
    
    resultadoAdmin <- getAdmin conn loginAdmin senhaAdmin
    if (resultadoAdmin /= [])
        then do
                result <- try (execute conn comando (dataVotacao, encerrada, abstencoes, nulos)) :: IO (Either SomeException Int64)
                case result of
                    Left err  -> putStrLn $ "Caught exception: " ++ show err
                    Right val -> print "Votacao cadastrada"
    else
        error "Erro no cadastro de nova votacao: Administrador não está cadastrado no sistema"
    return ()

getVotacaoById :: Connection -> Int -> IO [Votacao]
getVotacaoById conn idVotacao = do
    let comando = "SELECT * FROM votacao WHERE id = ?"

    query conn comando (Only (idVotacao :: Int)) :: IO [Votacao]

isVotacaoEncerrada :: Connection -> Int -> IO Bool
isVotacaoEncerrada conn idVotacao = do 
    votacaoList <- getVotacaoById conn idVotacao
    let votacao = head votacaoList

    return (encerrada votacao)