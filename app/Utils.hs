{-# LANGUAGE OverloadedStrings #-}
module Utils where

import Prelude hiding (filter)
import qualified Data.ByteString.Lazy as BL
import Data.Csv -- this is from the Cassava library
import qualified Data.Vector as V
import System.Directory (doesFileExist)
import Models.Estudante
import Text.Printf

data EstudanteCSV = EstudanteCSV {
    matricula:: String,
    senha:: String
} deriving (Show, Read, Eq)

-- Define how to get a FinancialInstrument from a record (CSV row)
-- by implementing the FromNamedRecord type class
instance FromNamedRecord EstudanteCSV where
  parseNamedRecord record =
    EstudanteCSV
      <$> record .: "matricula"
      <*> record .: "senha"

type ErrorMsg = String
-- type synonym to handle CSV contents
type CsvData = (Header, V.Vector EstudanteCSV)

removeHeaders :: CsvData -> V.Vector EstudanteCSV
removeHeaders = snd

-- Function to read the CSV
parseCsv :: FilePath -> IO (Either ErrorMsg CsvData)
parseCsv filePath = do
  fileExists <- doesFileExist filePath
  if fileExists
    then decodeByName <$> BL.readFile filePath
    else return . Left $ printf "The file %s does not exist" filePath

leEstudantes :: FilePath -> IO (Either ErrorMsg (V.Vector EstudanteCSV))
leEstudantes filePath =
  (fmap . fmap) -- lift the function twice
    removeHeaders -- remove headers and filter stocks
      (parseCsv filePath) -- read CSV from file path