{-# LANGUAGE OverloadedStrings #-}
module Controllers.EstudanteController where
import Database.PostgreSQL.Simple (Connection, ConnectInfo)
import Utils (leEstudantes, EstudanteCSV (matricula, senha))
import qualified Data.Vector as V
import Data.Vector (toList)
import Models.Estudante (cadastraEstudante, desativaEstudante)

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

desativarEstudante :: Connection -> String -> IO()
desativarEstudante conn matricula = do
    desativaEstudante conn matricula
    return ()