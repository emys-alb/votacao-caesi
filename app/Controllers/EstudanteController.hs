{-# LANGUAGE OverloadedStrings #-}
module Controllers.EstudanteController where
import Database.PostgreSQL.Simple (Connection, ConnectInfo)
import Utils (leEstudantes, EstudanteCSV (matricula, senha))
import qualified Data.Vector as V
import Data.Vector (toList)
import Models.Estudante (cadastraEstudante, getEstudante, editaSenhaEstudante, Estudante (Estudante), isEstudanteVotante, criaRelacaoEstudanteVotacao, verificaEstudanteNaoVotou)
import Control.Exception
import Data.Int
import Models.Chapa

cadastraEstudantes :: Connection -> String -> IO()
cadastraEstudantes conn filePath = do
    print ("Iniciando cadastro de estudantes a partir do arquivo " ++ filePath)
    info <- leEstudantes filePath
    case info of
        Left e -> putStrLn $ "Caught exception: " ++ show e
        Right estudantes -> do
            print "cadastrando estudantes"
            criaEstudanteBD conn (toList estudantes)

    return ()

criaEstudanteBD :: Connection -> [EstudanteCSV] -> IO()
criaEstudanteBD _ [] = print "Lista vazia"
criaEstudanteBD conn [estudante] = cadastraEstudante conn (matricula estudante) (senha estudante)
criaEstudanteBD conn (estudante:t) = do
    cadastraEstudante conn (matricula estudante) (senha estudante)
    criaEstudanteBD conn t

editaSenha :: Connection -> String -> String -> String -> IO()
editaSenha conn matricula senhaAtual novaSenha = do
    info <- try (getEstudante conn matricula senhaAtual) :: IO (Either SomeException [Estudante])
    case info of
        Left e -> putStrLn $ "Caught exception: " ++ show e
        Right estudante -> do
            if null estudante then putStrLn "Matricula ou senha incorretos"
            else editaSenhaEstudante conn matricula senhaAtual novaSenha

cadastraVoto :: Connection -> String -> String -> Int -> Int -> IO()
cadastraVoto conn matricula senha idVotacao numeroChapa = do
    isVotante <- isEstudanteVotante conn matricula senha

    if not isVotante then putStrLn "Estudante inexistente ou inativo"
    else do
        putStrLn "Estudante verificado"

        resultado <- try (getChapaVotacaoAtiva conn idVotacao numeroChapa) :: IO (Either SomeException [Chapa])
        case resultado of
            Left e -> putStrLn $ "Caught exception: " ++ show e
            Right chapaList -> do
                if null chapaList then putStrLn "Chapa não encontrada ou votação encerrada"
                else do
                    putStrLn "Chapa verificada"
                    estudanteNaoVotou <- verificaEstudanteNaoVotou conn matricula idVotacao
                    if estudanteNaoVotou then do
                        let chapa = head chapaList
                        criaRelacaoEstudanteVotacao conn matricula idVotacao
                        adicionaVoto conn (chapaId chapa)
                    else putStrLn "O estudante já cadastrou seu voto nesta votação"


cadastraVotoNulo :: Connection -> String -> String -> Int  -> IO()
cadastraVotoNulo conn matricula senha idVotacao = do
    isVotante <- isEstudanteVotante conn matricula senha

    if not isVotante then putStrLn "Estudante inexistente ou inativo"
    else do
        putStrLn "Estudante verificado"
        adicionaVotosNulo conn idVotacao
        criaRelacaoEstudanteVotacao conn matricula idVotacao