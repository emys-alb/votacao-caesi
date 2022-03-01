module Controllers.ChapaController where

import Database.PostgreSQL.Simple
import Control.Exception
import Models.Chapa
import Models.Estudante
import Models.Admin

cadastraEstudanteEmChapa :: Connection -> String -> String -> String -> Int -> String -> IO()
cadastraEstudanteEmChapa conn loginAdmin senhaAdmin matricula idChapa diretoria = do
    resultadoAdmin <- getAdmin conn loginAdmin senhaAdmin
    if resultadoAdmin /= []
        then do
            resultEstudante <- try (getEstudanteByMatricula conn matricula) :: IO (Either SomeException [Estudante])
            case resultEstudante of
                Left e -> putStrLn $ "Caught exception: " ++ show e
                Right estudante -> do
                    if null estudante then putStrLn "Estudante não encontrado"
                    else do
                        resultChapa <- try (getChapaById conn idChapa) :: IO (Either SomeException [Chapa])
                        case resultChapa of
                            Left e -> putStrLn $ "Caught exception: " ++ show e
                            Right chapa -> do
                                if null chapa then putStrLn "Chapa não encontrada"
                                else cadastraEstudanteChapa conn matricula idChapa (idVotacao (head chapa)) diretoria
    else
        putStrLn "Administrador não está cadastrado no sistema"