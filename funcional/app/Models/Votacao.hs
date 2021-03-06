{-# LANGUAGE OverloadedStrings #-}
module Models.Votacao where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.FromField
import Models.Admin
import Control.Exception
import Data.Int
import Models.Estudante (getQtdEstudantesVotantes)
-- import Controllers.ChapaController (getVotosEmChapas)


data Votacao = Votacao {
    id_votacao :: Int,
    dataVotacao:: String,
    encerrada:: Bool,
    abstencoes:: Int,
    nulos:: Int,
    empate:: Bool
 } deriving (Show, Read, Eq)

instance FromRow Votacao where
    fromRow = Votacao <$> field
                      <*> field
                      <*> field
                      <*> field
                      <*> field
                      <*> field

novaVotacao :: Connection -> String -> String -> String -> Bool -> Int -> Int -> Bool -> IO()
novaVotacao conn loginAdmin senhaAdmin dataVotacao encerrada abstencoes nulos empate = do
    let comando = "INSERT INTO votacao (data,\
                                       \encerrada,\
                                       \abstencoes,\
                                       \nulos,\
                                       \empate) VALUES (?, ?, ?, ?, ?)"

    resultadoAdmin <- getAdmin conn loginAdmin senhaAdmin
    if (resultadoAdmin /= [])
        then do
                result <- try (execute conn comando (dataVotacao, encerrada, abstencoes, nulos, empate)) :: IO (Either SomeException Int64)
                case result of
                    Left err  -> putStrLn $ "Caught exception: " ++ show err
                    Right val -> print "Votacao cadastrada"
    else
        putStrLn "Erro no cadastro de nova votacao: Administrador não está cadastrado no sistema"
    return ()

encerra :: Connection -> Int -> Int -> Bool -> IO()
encerra conn idVotacao abst empatou = do
    let comando = "UPDATE votacao SET encerrada = 't', abstencoes = ?, empate = ? WHERE id = ?;"

    result <- try (execute conn comando (abst, empatou, idVotacao)) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> print "Votacao encerrada"
    return ()

getVotacaoById :: Connection -> Int -> IO [Votacao]
getVotacaoById conn idVotacao = do
    let comando = "SELECT * FROM votacao WHERE id = ?"

    query conn comando (Only (idVotacao :: Int)) :: IO [Votacao]

comparacao :: Connection -> Int -> Int -> IO [Votacao]
comparacao conn idPrimeira idSegunda = do
    let comando = "SELECT * FROM votacao WHERE id = ? OR id = ?"

    query conn comando (idPrimeira, idSegunda) :: IO [Votacao]

getQtdVotosNulos :: Connection -> Int -> IO Int
getQtdVotosNulos conn idVotacao = do
    votacaoList <- getVotacaoById conn idVotacao
    let votacao = head votacaoList

    return (nulos votacao)

isVotacaoEncerrada :: Connection -> Int -> IO Bool
isVotacaoEncerrada conn idVotacao = do
    votacaoList <- getVotacaoById conn idVotacao
    let votacao = head votacaoList

    return (encerrada votacao)

adicionaVotoNulo :: Connection -> Int -> IO ()
adicionaVotoNulo conn idVotacao = do
    let q = "update votacao set nulos = nulos + 1 \
            \where id = ?"
    result <- try (execute conn q (Only (idVotacao :: Int))) :: IO (Either SomeException Int64)
    case result of
        Left err  -> putStrLn $ "Caught exception: " ++ show err
        Right val -> if val == 0 then putStrLn "Votação não encontrada" else putStrLn "Numero de votos atualizado"
    
    return ()

getTodasVotacoes :: Connection -> IO [Votacao]
getTodasVotacoes conn = do
    let comando = "SELECT * FROM votacao"

    query conn comando () :: IO [Votacao]
