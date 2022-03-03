module Controllers.ChapaController where

import Control.Exception
import Database.PostgreSQL.Simple
import Models.Chapa
import Models.Admin
import Models.Estudante
import Models.Votacao
import Control.Exception

adicionaVotoChapa :: Connection -> Int -> IO ()
adicionaVotoChapa conn idChapa = do
  adicionaVoto conn idChapa

getChapas :: Connection -> IO [ChapaVisualization]
getChapas conn = getChapasVotacaoAtiva conn

cadastraEstudanteEmChapa :: Connection -> String -> String -> String -> Int -> String -> IO ()
cadastraEstudanteEmChapa conn loginAdmin senhaAdmin matricula idChapa diretoria = do
  resultadoAdmin <- getAdmin conn loginAdmin senhaAdmin
  if resultadoAdmin /= []
    then do
      resultEstudante <- try (getEstudanteByMatricula conn matricula) :: IO (Either SomeException [Estudante])
      case resultEstudante of
        Left e -> putStrLn $ "Caught exception: " ++ show e
        Right estudante -> do
          if null estudante
            then putStrLn "Estudante não encontrado"
            else do
              resultChapa <- try (getChapaById conn idChapa) :: IO (Either SomeException [Chapa])
              case resultChapa of
                Left e -> putStrLn $ "Caught exception: " ++ show e
                Right chapa -> do
                  if null chapa
                    then putStrLn "Chapa não encontrada"
                  else cadastraEstudanteChapa conn matricula idChapa (idVotacao (head chapa)) diretoria
  else putStrLn "Administrador não está cadastrado no sistema"


removeEstudanteDaChapa :: Connection -> String -> String -> String -> Int -> IO()
removeEstudanteDaChapa conn loginAdmin senhaAdmin matricula idChapa = do
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
                                else removeEstudanteChapa conn matricula idChapa
    else
        putStrLn "Administrador não está cadastrado no sistema"

cadastraChapa :: Connection -> String -> String -> String -> Int -> Int -> IO ()
cadastraChapa conn loginAdmin senhaAdmin nomeChapa numeroChapa idVotacaoChapa = do
  cadastrarChapa conn loginAdmin senhaAdmin nomeChapa numeroChapa idVotacaoChapa

editaNomeChapa :: Connection -> String -> String -> Int -> String -> IO ()
editaNomeChapa conn login senha idChapa novoNome = do
  editarNomeChapa conn login senha idChapa novoNome

editaNumeroChapa :: Connection -> String -> String -> Int -> Int -> IO ()
editaNumeroChapa conn login senha idChapa novoNumero = do
    editarNumeroChapa conn login senha idChapa novoNumero

removeChapa :: Connection -> String -> String -> Int -> IO ()
removeChapa conn loginAdmin senhaAdmin idChapaRemocao = do
  removerChapa conn loginAdmin senhaAdmin idChapaRemocao

getVotosEmChapas :: Connection -> Int -> IO Int
getVotosEmChapas conn idVotacao = do
  getVotosChapasByVotacao conn idVotacao

getChapaVencedora :: Connection -> Int -> IO String
getChapaVencedora conn idVotacao = do
  chapaVencedora conn idVotacao

getQtdVotosVencedora :: Connection -> Int -> IO Int
getQtdVotosVencedora conn idVotacao = do
  qtdVotosVencedora conn idVotacao
