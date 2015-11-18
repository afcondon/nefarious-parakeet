module Main where

import S101
import Servant.Server
import Network.Wai.Handler.Warp

main :: IO ()
main = run 8080 (serve s101api)
