{-# LANGUAGE OverloadedStrings #-}
module Controllers.AdminController where
import Database.PostgreSQL.Simple
import Models.Admin

cadastraAdmin:: Connection -> String -> String -> String -> String -> IO ()
cadastraAdmin conn loginAdmin senhaAdmin novoLogin novaSenha = do
    cadastrarAdmin conn loginAdmin senhaAdmin novoLogin novaSenha 

listaAdmin:: Connection -> String -> String -> IO [Admin] 
listaAdmin conn login senha = do
    getAdmin conn login senha