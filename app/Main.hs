{-# LANGUAGE OverloadedStrings #-}

module Main where

import Graphics.EasyPlot
--import Graphics.Plotly

import System.IO
import Control.Monad ( forever )

--import Data.Time.Clock (getCurrentTime)

import Data.Function (on)
import Data.List (minimumBy, maximumBy, sortBy)
import Data.Ord (comparing)

import MyLib
    ( DataOB(_idUpdate, pAsk, pBid, midP, wgmidP, cummAsks, cummBids, dataOLS, regOLS, rSqr),
      Depth(Depth),
      Ticker(Ticker),
      ListDataOB,
      URL,
      constructUrl,
      getOrderBook,
      buildOBData )
import Utils ( ordersToDouble )
import SSC
--import Plotlyhs (vbarData)


main :: IO (Bool)
--main = do
main = forever $ do 
  ob <- MyLib.getOrderBook 
  let df_ob = MyLib.buildOBData ob 
  --print $ MyLib.dataOLS df_ob 
  {-
  print $ MyLib.cummAsks df_ob
  print $ MyLib.cummBids df_ob
  -}

  putStrLn "lastUpdateId:"
  print $ show (MyLib._idUpdate df_ob)
  putStrLn "Weighted mid-price:"
  print $ MyLib.wgmidP df_ob
  putStrLn "CJP martingale:"
  print $ (exp . snd) (MyLib.regOLS df_ob)
  putStrLn "Bid-Ask Spread in ticks:"
  print $ (MyLib.pBid df_ob - MyLib.pAsk df_ob ) / 0.0001
  putStrLn "R-Squared:"
  print $ MyLib.rSqr df_ob
  putStrLn "OLS Parameters"
  print $ MyLib.regOLS df_ob
  putStrLn "Press \'CTRL + C \' to stop."

