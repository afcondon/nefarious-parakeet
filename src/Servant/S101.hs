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

type S101API =
       "controller" :> "getVersion" :> Get '[JSON] VersionData

data VersionData =
  VersionData { version :: [Char], language :: [Char] } deriving (Eq, Show, Generic)
-- {"version":"4.0.5159","language":"javax"}

instance FromJSON VersionData where
  parseJSON (Object o) =
    VersionData <$> o .: "version"
                <*> o .: "language"

s101api :: Proxy S101API
s101api = Proxy
