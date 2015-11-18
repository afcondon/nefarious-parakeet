{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# OPTIONS_GHC -fno-warn-unused-binds #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

module S101
    ( results, api, myversion, S101api
    ) where

import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Either
import Data.Aeson
import Data.Monoid
import Data.Proxy
import Data.Text (Text)
import GHC.Generics
import Servant.API
import Servant.Client
import Network.Wai.Handler.Warp
import Servant
import Servant.Mock
import Test.QuickCheck.Arbitrary

import qualified Data.Text    as T
import qualified Data.Text.IO as T

-- {"version":"4.0.5159","language":"javax"}

type S101API =
       "controller" :> "getVersion" :> Get '[JSON] VersionData

data VersionData = VersionData { version :: Text, language :: Text } deriving (Eq, Show, Generic)

instance FromJSON VersionData where
  parseJSON (Object o) =
    VersionData <$> o .: "version"
                <*> o .: "language"

s101api :: Proxy S101API
s101api = Proxy

getVersion :: EitherT ServantError IO VersionData
getVersion = client s101api $ BaseUrl Http "24.226.52.201" 57777

results :: IO (Either ServantError ())
results = runEitherT $ do
  version <- getVersion
  liftIO . putStrLn $ "Version data from server: " ++ show version


-- | this stuff is for the mock servant-server

newtype User = User { username :: String }
  deriving (Eq, Show, Arbitrary, Generic)

instance ToJSON User

type API = "user" :> Get '[JSON] User

api :: Proxy API
api = Proxy

-- | and this bit is for the servant-server executable

myversion :: VersionData
myversion = VersionData { version = "0.0.0", language = "Haskell" }
