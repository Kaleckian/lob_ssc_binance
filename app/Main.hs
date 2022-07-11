{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO

import Control.Monad
import Control.Concurrent
import Control.Lens

import Network.Wreq
--import qualified ApiServer (apiServer)
--import qualified MyLib ()
--import qualified SSC (MyLib)

--import qualified MyLib (getTickers)
-- AESON JSON PARSER

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  rsp <- Network.Wreq.get "https://api.binance.com/api/v3/depth?limit=10&symbol=BTCUSDT"
  print rsp
  

getTickers :: IO ()
getTickers = do
  putStrLn "1 for ADA/USDT"
  putStrLn "2 for ADA/BRL"
  getLine >>= print
