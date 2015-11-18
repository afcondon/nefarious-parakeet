{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# OPTIONS_GHC -fno-warn-unused-binds #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Either
import Data.Aeson
import Data.Monoid
import Data.Proxy
import Data.Text (Text)
import GHC.Generics
import Servant
import Servant.Server
import Servant.API
import Network.Wai
import Network.Wai.Handler.Warp

import qualified Data.Text    as T
import qualified Data.Text.IO as T

import Servant.S101

-- | and this bit is for the servant-server executable

instance ToJSON VersionData

myversion :: VersionData
myversion = VersionData { version = "0.0.0", language = "Haskell" }

------

-- Server-side handlers.
--
-- There's one handler per endpoint, which, just like in the type
-- that represents the API, are glued together using :<|>.
--
-- Each handler runs in the 'ExceptT ServantErr IO' monad.
server :: Server S101API
server = return myversion

-- Turn the server into a WAI app. 'serve' is provided by servant,
-- more precisely by the Servant.Server module.
test :: Application
test = serve s101api server

-- Run the server.
--
-- 'run' comes from Network.Wai.Handler.Warp
runTestServer :: Port -> IO ()
runTestServer port = run port test

-- Put this all to work!
main :: IO ()
main = runTestServer 8001
