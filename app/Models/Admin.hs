{-# LANGUAGE OverloadedStrings #-}
module Models.Admin where
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.FromField
 
data Admin = Admin {
   login:: String,
   senha:: String
} deriving (Show, Read, Eq)
 
instance FromRow Admin where
   fromRow = Admin <$> field
                   <*> field
                  
 
getAdmin :: Connection -> String -> String -> IO [Admin]
getAdmin conn login senha = do
   let q = "select a.login, a.senha \
           \from admin a \
           \where a.login = ? AND a.senha = ?"
   query conn q (login, senha):: IO [Admin]
 
cadastrarAdmin :: Connection -> String -> String -> String -> String-> IO ()
cadastrarAdmin conn loginAdmin senhaAdmin novoLogin novaSenha = do
   let q = "insert into admin (login,\
               \senha) values (?,?)"
   resultadoAdmin <- getAdmin conn loginAdmin senhaAdmin
   if (resultadoAdmin /= []) || (novoLogin == novaSenha  && novoLogin == "admin")
       then execute conn q (novoLogin, novaSenha)
   else
       error "Erro no cadastro: Administrador não está cadastrado no sistema"
 
   return ()
 
editarSenhaAdmin :: Connection -> String -> String -> String-> IO ()
editarSenhaAdmin conn loginAdmin senhaAdmin novaSenhaAdmin = do
   let q = "update admin \
           \set senha = ? \
           \where login = ?"
   
   resultadoAdmin <- getAdmin conn loginAdmin senhaAdmin
   if resultadoAdmin /= []
       then execute conn q (novaSenhaAdmin, loginAdmin)
   else
       error "Erro atualizando senha: Administrador não está cadastrado no sistema"
    
    return ()