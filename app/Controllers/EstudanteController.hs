{-# LANGUAGE OverloadedStrings #-}
module Controllers.EstudanteController where
import Database.PostgreSQL.Simple (Connection, ConnectInfo)
import Utils (leEstudantes, EstudanteCSV (matricula, senha))
import qualified Data.Vector as V
import Data.Vector (toList)
import Models.Estudante (cadastraEstudante, getEstudante, editaSenhaEstudante, desativaEstudante, Estudante (Estudante))
import Control.Exception
import Data.Int
import Models.Admin

cadastraEstudantes :: Connection -> String -> String -> String -> IO()
cadastraEstudantes conn loginAdmin senhaAdmin filePath = do
    print ("Iniciando cadastro de estudantes a partir do arquivo " ++ filePath)
    resultadoAdmin <- getAdmin conn loginAdmin senhaAdmin
    if resultadoAdmin /= []
        then do
            info <- leEstudantes filePath
            case info of
                Left e -> putStrLn $ "Caught exception: " ++ show e
                Right estudantes -> do
                    print "cadastrando estudantes"
                    criaEstudanteBD conn (toList estudantes)
    else
        putStrLn "Erro no cadastro: Administrador não está cadastrado no sistema"
    

    return ()

criaEstudanteBD :: Connection -> [EstudanteCSV] -> IO()
criaEstudanteBD _ [] = print "Lista vazia"
criaEstudanteBD conn [estudante] = cadastraEstudante conn (matricula estudante) (Utils.senha estudante)
criaEstudanteBD conn (estudante:t) = do
    cadastraEstudante conn (matricula estudante) (Utils.senha estudante)
    criaEstudanteBD conn t

desativarEstudante :: Connection -> String -> String -> String-> IO()
desativarEstudante conn loginAdmin senhaAdmin matricula = do
    resultadoAdmin <- getAdmin conn loginAdmin senhaAdmin
    if resultadoAdmin /= []
        then do
            desativaEstudante conn matricula
    else
        putStrLn "Erro na desativação: Administrador não está cadastrado no sistema"

    return ()


editaSenha :: Connection -> String -> String -> String -> IO()
editaSenha conn matricula senhaAtual novaSenha = do
    info <- try (getEstudante conn matricula senhaAtual) :: IO (Either SomeException [Estudante])
    case info of
        Left e -> putStrLn $ "Caught exception: " ++ show e
        Right estudante -> do
            if null estudante then putStrLn "Matricula ou senha incorretos"
            else editaSenhaEstudante conn matricula senhaAtual novaSenha
