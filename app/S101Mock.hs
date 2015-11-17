module Main where

import S101
import Network.Wai.Handler.Warp
import Servant.Server
import Servant.Mock

main :: IO ()
main = run 8080 (serve api $ mock api)
