{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Either
import Servant.Client
import Servant

import qualified Data.Text    as T
import qualified Data.Text.IO as T

import Servant.S101

getVersion :: EitherT ServantError IO VersionData
--getVersion = client s101api $ BaseUrl Http "24.226.52.201" 57777
getVersion = client s101api $ BaseUrl Http "localhost" 8001

results :: IO (Either ServantError ())
results = runEitherT $ do
  version <- getVersion
  liftIO . putStrLn $ "Version data from server: " ++ show version

main :: IO ()
main = print =<< results
