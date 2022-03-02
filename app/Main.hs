<<<<<<< HEAD
module Main where

import Controllers.AdminController
import Controllers.ChapaController
import Controllers.EstudanteController
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Models.Admin (Admin (login, senha))

mostraOpcoes :: Connection -> IO ()
mostraOpcoes conn = do
  putStrLn
    "Menu de atividades: \
    \\n 1 - Cadastra o primeiro admin\
    \\n 2 - Cadastra novo administrador\
    \\n 3 - Remove administrador\
    \\n 4 - Edita senha do administrador\
    \\n 5 - Cadastra estudantes\
    \\n 6 - Edita senha do estudante\
    \\n 7 - Desativa estudante\
    \\n 8 - Cadastra votação\
    \\n 9 - Cadastra chapa\
    \\n 10 - Edita chapa\
    \\n 11 - Remove chapa\
    \\n 12 - Cadastra voto de estudante\
    \\n 13 - Lista dados da votação\
    \\n 14 - Lista histórico de votações\
    \\n 15 - Compara votações\
    \\n 16 - Sair"

  inputOpcao <- getLine
  if inputOpcao /= "16"
    then do
      menu inputOpcao conn
      mostraOpcoes conn
    else putStrLn "Fechando sistema"

main :: IO ()
main = do
  conn <- iniciandoDatabase
  putStrLn "Base de dados criada"

  mostraOpcoes conn

menu :: String -> Connection -> IO ()
menu opcao conn
  | opcao == "1" = cadastroPrimeiroAdmin conn
  | opcao == "2" = cadastroNovoAdmin conn
  | opcao == "5" = cadastroNovosEstudantes conn
  | opcao == "6" = editarSenhaEstudante conn
  | opcao == "9" = cadastraChapas conn

cadastroPrimeiroAdmin :: Connection -> IO ()
cadastroPrimeiroAdmin conn = do
  putStrLn "O primeiro admin tem login e senha: admin"
  cadastraAdmin conn "" "" "admin" "admin"

cadastroNovoAdmin :: Connection -> IO ()
cadastroNovoAdmin conn = do
  putStrLn "Cadastro de novo administrador"

  putStrLn "Insira seu login como administrador"
  loginAdmin <- getLine
  putStrLn "Insira sua senha como administrador"
  senhaAdmin <- getLine
  putStrLn "Insira o login do novo administrador"
  loginNovoAdmin <- getLine
  putStrLn "Insira a senha do novo administrador"
  senhaNovoAdmin <- getLine

  cadastraAdmin conn loginAdmin senhaAdmin loginNovoAdmin senhaNovoAdmin

cadastroNovosEstudantes :: Connection -> IO ()
cadastroNovosEstudantes conn = do
  putStrLn "Cadastro de novos estudantes"
  putStrLn "Insira seu login como administrador"
  loginAdmin <- getLine
  putStrLn "Insira sua senha como administrador"
  senhaAdmin <- getLine
  putStrLn "Insira o caminho para o arquivo .csv que deve conter duas colunas (matricula e senha) para cada estudante"
  caminho <- getLine
  --adicionar aqui o metodo de verificarAdmin
  cadastraEstudantes conn caminho

editarSenhaEstudante :: Connection -> IO ()
editarSenhaEstudante conn = do
  putStrLn "Editar senha do estudante"
  putStrLn "Insira sua matrícula"
  matricula <- getLine
  putStrLn "Insira sua senha atual"
  senhaAtual <- getLine
  putStrLn "Insira sua nova senha"
  novaSenha <- getLine
  editaSenha conn matricula senhaAtual novaSenha

cadastraChapas :: Connection -> IO ()
cadastraChapas conn = do
  putStrLn "Cadastrar Chapa"
  putStrLn "Insira o login do Admin:"
  loginAdmin <- getLine
  putStrLn "Insira sua senha:"
  senhaAdmin <- getLine
  putStrLn "Insira o nome da chapa:"
  nomeChapa <- getLine
  putStrLn "Insira o número da chapa"
  numeroChapa <- getLine
  putStrLn "Insira o ID da votação"
  idVotacaoChapa <- getLine
  cadastraChapa conn loginAdmin senhaAdmin nomeChapa (read numeroChapa) (read idVotacaoChapa)
=======
module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController
import Controllers.EstudanteController
import Controllers.VotacaoController
import Controllers.ChapaController
import Models.Chapa
import Models.Estudante (Estudante(matricula))

mostraOpcoes :: Connection -> IO()
mostraOpcoes conn = do
    putStrLn "Menu de atividades: \
    \\n 1 - Cadastra o primeiro admin\
    \\n 2 - Cadastra novo administrador\
    \\n 3 - Remove administrador\
    \\n 4 - Edita senha do administrador\
    \\n 5 - Cadastra estudantes\
    \\n 6 - Edita senha do estudante\
    \\n 7 - Desativa estudante\
    \\n 8 - Cadastra votação\
    \\n 9 - Cadastra chapa\
    \\n 10 - Cadastra estudante em chapa\
    \\n 11 - Edita chapa\
    \\n 12 - Remove chapa\
    \\n 13 - Cadastra voto de estudante\
    \\n 14 - Lista dados da votação\
    \\n 15 - Lista histórico de votações\
    \\n 16 - Compara votações\
    \\n 17 - Sair"

    inputOpcao <- getLine
    if inputOpcao /= "17" then do
        menu inputOpcao conn
        mostraOpcoes conn
    else
        putStrLn "Fechando sistema"

main :: IO()
main = do
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"

    mostraOpcoes conn


menu :: String -> Connection -> IO ()
menu opcao conn
    | opcao == "1" = cadastroPrimeiroAdmin conn
    | opcao == "2" = cadastroNovoAdmin conn
    | opcao == "3" = removeAdministrador conn
    | opcao == "4" = editaSenhaAdmins conn
    | opcao == "5" = cadastroNovosEstudantes conn
    | opcao == "6" = editarSenhaEstudante conn
    | opcao == "7" = desativaEstudante conn
    | opcao == "8" = cadastroVotacao conn
    | opcao == "10" = cadastroEstudanteChapa conn
    | opcao == "13" = cadastraVotoEstudante conn
    | otherwise = putStrLn "Opção inválida"

cadastroPrimeiroAdmin :: Connection -> IO()
cadastroPrimeiroAdmin conn = do
    putStrLn "O primeiro admin tem login e senha: admin"
    cadastraAdmin conn "" "" "admin" "admin"

cadastroNovoAdmin :: Connection -> IO()
cadastroNovoAdmin conn = do
    putStrLn "Cadastro de novo administrador"

    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira o login do novo administrador"
    loginNovoAdmin <- getLine
    putStrLn "Insira a senha do novo administrador"
    senhaNovoAdmin <- getLine

    cadastraAdmin conn loginAdmin senhaAdmin loginNovoAdmin senhaNovoAdmin

removeAdministrador :: Connection -> IO ()
removeAdministrador conn = do
    putStrLn "Remove administrador"

    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira o login do administrador a ser removido"
    loginAdminRemovido <- getLine

    removeAdmin conn loginAdmin senhaAdmin loginAdminRemovido

editaSenhaAdmins :: Connection -> IO()
editaSenhaAdmins conn = do
    putStrLn "Atualiza senha do administrador"

    putStrLn "Insira seu login como administrador:"
    loginAdmin <- getLine
    putStrLn "Insira a senha atual:"
    senhaAdmin <- getLine 
    putStrLn "Insira a nova senha:"
    novaSenhaAdmin <- getLine 
    editaSenhaAdmin conn loginAdmin senhaAdmin novaSenhaAdmin

cadastroNovosEstudantes :: Connection -> IO()
cadastroNovosEstudantes conn = do
    putStrLn "Cadastro de novos estudantes"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira o caminho para o arquivo .csv que deve conter duas colunas (matricula e senha) para cada estudante"
    caminho <- getLine
    cadastraEstudantes conn loginAdmin senhaAdmin caminho
    
desativaEstudante :: Connection -> IO()
desativaEstudante conn = do
    putStrLn "Desativação de estudante"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a matrícula do estudante a ser desativado"
    matricula <- getLine
    desativarEstudante conn loginAdmin senhaAdmin matricula

editarSenhaEstudante :: Connection -> IO()
editarSenhaEstudante conn = do
    putStrLn "Editar senha do estudante"
    putStrLn "Insira sua matrícula"
    matricula <- getLine
    putStrLn "Insira sua senha atual"
    senhaAtual <- getLine
    putStrLn "Insira sua nova senha"
    novaSenha <- getLine
    editaSenha conn matricula senhaAtual novaSenha

cadastroVotacao :: Connection -> IO()
cadastroVotacao conn = do
    putStrLn "Cadastrar uma nova votação"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a data da nova votação"
    dataVotacao <- getLine

    cadastraVotacao conn loginAdmin senhaAdmin dataVotacao

<<<<<<< HEAD
>>>>>>> a4d71d430b9bc33ae66a2ce1da983eb7946c9c02
=======
printChapas :: [ChapaVisualization] -> IO ()
printChapas [] = putStrLn ""
printChapas [chapa] = putStrLn ("Votacao id " ++ show (votacaoId chapa) ++ " - Chapa numero " ++ show (numeroChapa chapa)  ++ " - " ++ nomeChapa chapa)
printChapas (chapa:t) = do
    putStrLn ("Votacao id " ++ show (votacaoId chapa) ++ " - Chapa numero " ++ show (numeroChapa chapa)  ++ " - " ++ nomeChapa chapa)
    printChapas t

cadastraVotoEstudante :: Connection -> IO ()
cadastraVotoEstudante conn = do
    putStrLn "Insira sua matricula"
    matricula <- getLine
    putStrLn "Insira sua senha"
    senha <- getLine
    chapas <- getChapasVotacaoAtiva conn
    printChapas chapas
    putStrLn "Insira id da votacao"
    idVotacao <- getLine
    putStrLn "Insira o numero da chapa escolhida"
    putStrLn "Caso deseje votar nulo, digite n"
    numeroChapa <- getLine

    if numeroChapa == "n" then cadastraVotoNulo conn matricula senha (read idVotacao)
    else cadastraVoto conn matricula senha (read idVotacao) (read numeroChapa)

cadastroEstudanteChapa :: Connection -> IO ()
cadastroEstudanteChapa conn = do
    putStrLn "Cadastro de estudante em chapa"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a matricula do estudante"
    matricula <- getLine
    putStrLn "Insira o id da chapa"
    idChapa <- getLine
    putStrLn "Insira a diretoria do estudante candidato"
    diretoria <- getLine

    cadastraEstudanteEmChapa conn loginAdmin senhaAdmin matricula (read idChapa) diretoria

>>>>>>> f3f48a1db1132c5e41caebf9f462a7bab658cd47
