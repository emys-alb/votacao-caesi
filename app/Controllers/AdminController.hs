module Controllers.AdminController where
import Database.PostgreSQL.Simple

cadastrarAdmin :: Connection -> String -> String -> IO ()
cadastrarAdmin conn login senha = do
    let q = "insert into admin (login,\
                \senha) values (?,?)" 
    execute conn q (login, senha)
    return ()