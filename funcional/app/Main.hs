module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdminController
import Controllers.EstudanteController
import Controllers.VotacaoController
import Controllers.ChapaController
import Models.Chapa
import Models.Votacao
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
    \\n 11 - Remove estudante da chapa\
    \\n 12 - Edita chapa\
    \\n 13 - Remove chapa\
    \\n 14 - Cadastra voto de estudante\
    \\n 15 - Encerra votação\
    \\n 16 - Lista dados da votação\
    \\n 17 - Lista histórico de votações\
    \\n 18 - Compara votações\
    \\n 19 - Sair"

    inputOpcao <- getLine
    if inputOpcao /= "19" then do
        menu inputOpcao conn
        mostraOpcoes conn
    else
        putStrLn "\nFechando sistema\n"

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
    | opcao == "9" = cadastraChapas conn
    | opcao == "10" = cadastroEstudanteChapa conn
    | opcao == "11" = removerEstudanteDaChapa conn
    | opcao == "12" = editaChapa conn
    | opcao == "13" = removeChapas conn
    | opcao == "14" = cadastraVotoEstudante conn
    | opcao == "15" = encerrarVotacao conn
    | opcao == "16" = listaDadosVotacao conn
    | opcao == "17" = listaHistoricoEleicoes conn
    | opcao == "18" = comparacaoEleicoes conn
    | otherwise = putStrLn "Opção inválida"

cadastroPrimeiroAdmin :: Connection -> IO()
cadastroPrimeiroAdmin conn = do
    putStrLn "O primeiro admin tem login e senha: admin"
    cadastraAdmin conn "" "" "admin" "admin"

cadastroNovoAdmin :: Connection -> IO()
cadastroNovoAdmin conn = do
    putStrLn "\nCadastro de novo administrador\n"

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
    putStrLn "\nRemove administrador\n"

    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira o login do administrador a ser removido"
    loginAdminRemovido <- getLine

    removeAdmin conn loginAdmin senhaAdmin loginAdminRemovido

editaSenhaAdmins :: Connection -> IO()
editaSenhaAdmins conn = do
    putStrLn "\nAtualiza senha do administrador\n"

    putStrLn "Insira seu login como administrador:"
    loginAdmin <- getLine
    putStrLn "Insira a senha atual:"
    senhaAdmin <- getLine
    putStrLn "Insira a nova senha:"
    novaSenhaAdmin <- getLine
    editaSenhaAdmin conn loginAdmin senhaAdmin novaSenhaAdmin

cadastroNovosEstudantes :: Connection -> IO()
cadastroNovosEstudantes conn = do
    putStrLn "\nCadastro de novos estudantes\n"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira o caminho para o arquivo .csv que deve conter duas colunas (matricula e senha) para cada estudante"
    caminho <- getLine
    cadastraEstudantes conn loginAdmin senhaAdmin caminho

desativaEstudante :: Connection -> IO()
desativaEstudante conn = do
    putStrLn "\nDesativação de estudante\n"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a matrícula do estudante a ser desativado"
    matricula <- getLine
    desativarEstudante conn loginAdmin senhaAdmin matricula

editarSenhaEstudante :: Connection -> IO()
editarSenhaEstudante conn = do
    putStrLn "\nEditar senha do estudante\n"
    putStrLn "Insira sua matrícula"
    matricula <- getLine
    putStrLn "Insira sua senha atual"
    senhaAtual <- getLine
    putStrLn "Insira sua nova senha"
    novaSenha <- getLine
    editaSenha conn matricula senhaAtual novaSenha

cadastroVotacao :: Connection -> IO()
cadastroVotacao conn = do
    putStrLn "\nCadastrar uma nova votação\n"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a data da nova votação"
    dataVotacao <- getLine

    cadastraVotacao conn loginAdmin senhaAdmin dataVotacao

encerrarVotacao :: Connection -> IO()
encerrarVotacao conn = do
    putStrLn "\nEncerrar votação\n"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira o id da votação a ser encerrada"
    idVotacao <- getLine

    encerraVotacao conn loginAdmin senhaAdmin (read idVotacao)

comparacaoEleicoes :: Connection -> IO()
comparacaoEleicoes conn = do
    putStrLn "\nComparar duas eleicoes\n"

    putStrLn "Insira o ID da primeira votacao"
    idPrimeira <- getLine
    putStrLn "Insira o ID da segunda votacao"
    idSegunda <- getLine

    primeira <- getVotacao conn (read idPrimeira)
    segunda <- getVotacao conn (read idSegunda)

    if null primeira || null segunda then putStrLn "Votação não encontrada"
    else do
      if empate (head primeira) || empate (head segunda) then putStrLn "Não é possível fazer a comparação de votações pois uma das votações resultou em um empate"
      else do
        primeiraEncerrada <- votacaoEncerrada conn (read idPrimeira)
        segundaEncerrada <- votacaoEncerrada conn (read idSegunda)

        if not (primeiraEncerrada && segundaEncerrada) then putStrLn "Só é possível fazer comparações de votações encerradas"
        else do
            totalVotosPrimeira <- getTotalVotosVotacao conn (read idPrimeira)
            totalVotosSegunda <- getTotalVotosVotacao conn (read idSegunda)

            putStrLn "TOTAL DE VOTOS"
            print ("Votacao " ++ idPrimeira ++ ": " ++ show totalVotosPrimeira ++ " votos")
            print ("Votacao " ++ idSegunda ++ ": " ++ show totalVotosSegunda ++ " votos")
            
            putStrLn "VOTOS NULOS"
            print ("Votacao " ++ idPrimeira ++ ": " ++ show (nulos (head primeira)) ++ " votos nulos")
            print ("Votacao " ++ idSegunda ++ ": " ++ show (nulos (head segunda)) ++ " votos nulos")

            putStrLn "ABSTENÇÕES"
            putStrLn ("Votacao " ++ idPrimeira ++ ": " ++ show (abstencoes (head primeira)) ++ " abstenções")
            putStrLn ("Votacao " ++ idSegunda ++ ": " ++ show (abstencoes (head segunda)) ++ " abstenções")

            vencedoraPrimeira <- getChapaVencedora conn (read idPrimeira)
            votosVencedoraPrimeira <- getQtdVotosVencedora conn (read idPrimeira)
            vencedoraSegunda <- getChapaVencedora conn (read idSegunda)
            votosVencedoraSegunda <- getQtdVotosVencedora conn (read idSegunda)

            putStrLn "CHAPA VENCEDORA"
            putStrLn ("Votacao " ++ idPrimeira ++ ": " ++ show vencedoraPrimeira ++ ": " ++ show votosVencedoraPrimeira ++ " votos")
            putStrLn ("Votacao " ++ idSegunda ++ ": " ++ show vencedoraSegunda ++ ": " ++ show votosVencedoraSegunda ++ " votos")


printVotosChapas :: [Chapa] -> IO ()
printVotosChapas [] = putStrLn ""
printVotosChapas [chapa] = putStrLn (nome chapa ++ " - " ++ show (numDeVotos chapa)  ++  " votos")
printVotosChapas (chapa:t) = do
    putStrLn (nome chapa ++ " - " ++ show (numDeVotos chapa)  ++  " votos")
    printVotosChapas t

printVotacoes :: Connection -> [Votacao] -> IO()
printVotacoes _ [] = putStrLn ""
printVotacoes conn [votacao] = do
    putStrLn ("\nID - " ++ show (id_votacao votacao) ++  "\nData - " ++ show (dataVotacao votacao))
    putStrLn ("Votos nulos - " ++ show (nulos votacao))
    putStrLn ("Abstenções - " ++ show (abstencoes votacao))
    chapas <- getChapasDeUmaVotacao conn (id_votacao votacao)
    printVotosChapas chapas
    putStrLn ""
printVotacoes conn (votacao:t) = do
    putStrLn ("\nID - " ++ show (id_votacao votacao) ++  "\nData - " ++ show (dataVotacao votacao))
    putStrLn ("Votos nulos - " ++ show (nulos votacao))
    putStrLn ("Abstenções - " ++ show (abstencoes votacao))
    chapas <- getChapasDeUmaVotacao conn (id_votacao votacao)
    printVotosChapas chapas
    putStrLn ""
    printVotacoes conn t

listaHistoricoEleicoes :: Connection -> IO()
listaHistoricoEleicoes conn = do
    putStrLn "Listar histórico de eleicoes"
    historico <- listarTodasVotacoes conn

    printVotacoes conn historico

listaDadosVotacao :: Connection -> IO()
listaDadosVotacao conn = do
    putStrLn "Listar dados de uma votação"
    putStrLn "Insira o ID da Votação"
    id <- getLine

    dadosVotacao <- getVotacao conn (read id)

    printVotacoes conn dadosVotacao


cadastraChapas :: Connection -> IO ()
cadastraChapas conn = do
  putStrLn "\nCadastrar Chapa\n"
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

editaChapa :: Connection -> IO ()
editaChapa conn = do
    putStrLn "\nEditar Chapa\n"

    chapas <- getChapasVotacaoAtiva conn
    printChapas chapas

    putStrLn "\nInsira o login do Admin:"
    loginAdmin <- getLine
    putStrLn "Insira sua senha:"
    senhaAdmin <- getLine
    putStrLn "Insira o ID da chapa"
    idChapa <- getLine

    putStrLn "Insira: \
            \\n 1 - para editar nome da chapa\
            \\n 2 - para editar o numero da chapa"

    opcao <- getLine
    if opcao == "1"
        then do
            putStrLn "Insira o novo nome da chapa"
            novoNome <- getLine
            editaNomeChapa conn loginAdmin senhaAdmin (read idChapa) novoNome
    else if opcao == "2"
        then do
            putStrLn "Insira o novo numero da chapa"
            novoNumero <- getLine
            editaNumeroChapa conn loginAdmin senhaAdmin (read idChapa) (read novoNumero)
    else
        putStrLn "Opção inválida"

printChapas :: [ChapaVisualization] -> IO ()
printChapas [] = putStrLn ""
printChapas [chapa] = putStrLn ("Votacao id " ++ show (votacaoId chapa) ++ " - Id da Chapa " ++ show (idChapa chapa)  ++  " - Chapa numero " ++ show (numeroChapa chapa)  ++ " - " ++ nomeChapa chapa)
printChapas (chapa:t) = do
    putStrLn ("Votacao id " ++ show (votacaoId chapa) ++ " - Id da Chapa " ++ show (idChapa chapa)  ++ " - Chapa numero " ++ show (numeroChapa chapa)  ++ " - " ++ nomeChapa chapa)
    printChapas t

cadastraVotoEstudante :: Connection -> IO ()
cadastraVotoEstudante conn = do
    putStrLn "\nCadastro de voto de estudante\n"
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
    putStrLn "\nCadastro de estudante em chapa\n"
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

removerEstudanteDaChapa :: Connection -> IO ()
removerEstudanteDaChapa conn = do
    putStrLn "\nRemove de estudante da chapa\n"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira a matricula do estudante"
    matricula <- getLine
    putStrLn "Insira o id da chapa"
    idChapa <- getLine

    removeEstudanteDaChapa conn loginAdmin senhaAdmin matricula (read idChapa)

removeChapas :: Connection -> IO ()
removeChapas conn = do
    putStrLn "\nRemove chapa\n"
    putStrLn "Insira seu login como administrador"
    loginAdmin <- getLine
    putStrLn "Insira sua senha como administrador"
    senhaAdmin <- getLine
    putStrLn "Insira id da chapa a ser removida"
    idChapaRemocao <- getLine
    removeChapa conn loginAdmin senhaAdmin (read idChapaRemocao)
