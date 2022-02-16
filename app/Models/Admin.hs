module Models.Admin where

data Admin = Admin {
    login:: String,
    senha:: String
} deriving (Show, Read, Eq)
