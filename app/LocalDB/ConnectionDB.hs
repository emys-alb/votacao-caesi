{-# LANGUAGE OverloadedStrings #-}
module LocalDB.ConnectionDB where
import Database.PostgreSQL.Simple

localDB:: ConnectInfo
localDB = defaultConnectInfo {
    connectHost = "localhost",
    connectDatabase = "votacao_caesi",
    connectUser = "postgres",
    connectPassword = "password",
    connectPort = 5432
}

connectionMyDB :: IO Connection
connectionMyDB = connect localDB

createEstudante :: Connection -> IO()
createEstudante conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS estudante (\
                    \matricula VARCHAR(50) PRIMARY KEY,\
                    \senha VARCHAR(15) NOT NULL,\
                    \votante BOOLEAN NOT NULL);"
    return ()

iniciandoDatabase :: IO Connection
iniciandoDatabase = do
		c <- connectionMyDB
		createEstudante c
		return c