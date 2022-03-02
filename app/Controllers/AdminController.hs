{-# LANGUAGE OverloadedStrings #-}
module Controllers.AdminController where
import Database.PostgreSQL.Simple
import Models.Admin


verificaAdmin:: Connection -> String -> String -> IO [Admin] 
verificaAdmin conn login senha = do
    getAdmin conn login senha

cadastraAdmin:: Connection -> String -> String -> String -> String -> IO ()
cadastraAdmin conn loginAdmin senhaAdmin novoLogin novaSenha = do
    cadastrarAdmin conn loginAdmin senhaAdmin novoLogin novaSenha 

removeAdmin:: Connection -> String -> String -> String -> IO ()
removeAdmin conn loginAdmin senhaAdmin loginAdminRemovido = do
    removerAdmin conn loginAdmin senhaAdmin loginAdminRemovido
    
editaSenhaAdmin:: Connection -> String -> String -> String -> IO ()
editaSenhaAdmin conn loginAdmin senhaAdmin novaSenhaAdmin = do
   editarSenhaAdmin conn loginAdmin senhaAdmin novaSenhaAdmin
