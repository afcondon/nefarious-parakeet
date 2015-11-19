{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Servant.S101 where

import Data.Monoid
import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Either
import Data.Aeson
import Data.Proxy
import Data.Text (Text)
import GHC.Generics
import Servant
import Servant.API
import Servant.Mock
import Servant.Client
import Test.QuickCheck.Arbitrary

-- | Types and instances needed for this API
data VersionData =
  VersionData { version :: [Char], language :: [Char] } deriving (Eq, Show, Generic)
-- {"version":"4.0.5159","language":"javax"}

instance FromJSON VersionData where
  parseJSON (Object o) =
    VersionData <$> o .: "version"
                <*> o .: "language"

-- | API specification, S101API definition is composed of various routes, defined below
type S101API = GetVersion :<|> StopServer

-- | A 'GET' request against /:controller/getVersion with a JSON encoded response body
type GetVersion =
       "controller" :> "getVersion" :> Get '[JSON] VersionData

-- | A 'GET' request against /:controller/stopServer
type StopServer =
       "controller" :> "stopServer" :> Get '[JSON] ()

-- | the only piece of boilerplate needed in Servant
-- s101api :: Proxy GetVersion
s101api :: Proxy S101API
s101api = Proxy

gvproxy :: Proxy GetVersion
gvproxy = Proxy
