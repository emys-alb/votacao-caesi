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
