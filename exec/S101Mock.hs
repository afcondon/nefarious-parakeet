{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE OverloadedStrings          #-}
import           Data.Aeson
import           GHC.Generics
import           Network.Wai.Handler.Warp
import           Servant
import           Servant.Mock
import Test.QuickCheck.Arbitrary

import Servant.S101

-- | this stuff is for the mock servant-server

instance ToJSON VersionData
instance Arbitrary VersionData where
  arbitrary = do
    l <- arbitrary
    v <- arbitrary
    return VersionData { version = v, language = l }

main :: IO ()
main = run 8080 (serve s101api $ mock s101api)
