{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-unused-binds #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

module Lib
    ( uselessNumbers
    ) where

import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Either
import
import Data.Aeson
import Data.Monoid
import Data.Proxy
import Data.Text (Text)
import GHC.Generics
import Servant.API
import Servant.Client
import Servant.Server
import Servant.Mock
import Test.QuickCheck.Arbitrary

import qualified Data.Text    as T
import qualified Data.Text.IO as T

type PlaceholderAPI =
       "users" :> Get '[JSON] [UserDetailed]
  :<|> "albums" :> Get '[JSON] [Album]

type Username = Text
type Name     = Text
type Email    = Text
type Phone    = Text
type Website  = Text
type BS       = Text
type CatchPhrase = Text
type Street   = Text
type Suite    = Text
type City     = Text
type Zipcode  = Text
type Lat      = Text
type Lng      = Text

data Album = Album
  { userId :: Int
  , id     :: Int
  , title  :: Text
  } deriving (Eq, Show, Generic)

instance FromJSON Album where
  parseJSON (Object o) =
    Album <$> o .: "userId"
          <*> o .: "id"
          <*> o .: "title"

  parseJSON _ = mzero


data UserDetailed = UserDetailed
  { uid       :: Int  -- clash with id in Album
  , name     :: Name
  , username :: Username
  , email    :: Email
  , address  :: Address
  , phone    :: Phone
  , website  :: Website
  , company  :: Company
  } deriving (Eq, Show, Generic)

data Geo = Geo
  { lat :: Lat
  , lng :: Lng
  } deriving (Eq, Show, Generic)

data Address = Address
  { street  :: Street
  , suite   :: Suite
  , city    :: City
  , zipcode :: Zipcode
  , geo :: Geo
  } deriving (Eq, Show, Generic)

data Company = Company
  { companyname :: Name   -- clash with name in UserDetailed
  , catchPhrase :: CatchPhrase
  , bs          :: BS
  } deriving (Eq, Show, Generic)

instance FromJSON UserDetailed
instance FromJSON Geo
instance FromJSON Address
instance FromJSON Company

placeholderAPI :: Proxy PlaceholderAPI
placeholderAPI = Proxy

getUsers :: EitherT ServantError IO [UserDetailed]
getUsers :<|> getAlbums = client placeholderAPI $ BaseUrl Http "jsonplaceholder.typicode.com" 80

uselessNumbers :: IO (Either ServantError ())
uselessNumbers = runEitherT $ do
  albums <- getAlbums
  liftIO . putStrLn $ show (length albums) ++ " albums" ++ show albums
