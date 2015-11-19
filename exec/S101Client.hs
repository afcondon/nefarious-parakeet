{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Either
import Options.Applicative
import Servant.Client
import Servant

import qualified Data.Text    as T
import qualified Data.Text.IO as T

import Servant.S101

{-
getVersion = client s101api $ BaseUrl Http "localhost" 8001    -- local haskell server
getVersion = client s101api $ BaseUrl Http "localhost" 8080    -- local mock server
getVersion = client s101api $ BaseUrl Http "24.226.52.201" 57777
-}

getVersion :: ClientDetails -> EitherT ServantError IO VersionData
getVersion (ClientDetails host port) = client s101api $ BaseUrl Http host port

results :: ClientDetails -> IO (Either ServantError ())
results c = runEitherT $ do
  version <- getVersion c
  liftIO . putStrLn $ "Version data from server: " ++ show version

--------------------------------------------------------

data ClientDetails = ClientDetails
  { host :: String
  , port :: Int }
  deriving Show

clientdetails :: Parser ClientDetails
clientdetails = ClientDetails
     <$> strOption
         ( long "host"
        <> value "localhost"
        <> short 'h'
        <> metavar "HOST"
        <> help "Hostname to contact" )
     <*> option auto
         ( long "port"
        <> value 8001
        <> short 'p'
        <> metavar "PORT"
        <> help "Port number (defaults to 8000)" )

opts :: ParserInfo ClientDetails
opts = info (clientdetails <**> helper)
  ( fullDesc
 <> progDesc "Makes call to S101 API on http://HOST:PORT"
 <> header "S101 JSON API Haskell Client" )

greet :: ClientDetails -> IO ()
greet (ClientDetails h p) = putStrLn $ "Hello, " ++ h

main :: IO ()
main = execParser opts >>= results >>= print
