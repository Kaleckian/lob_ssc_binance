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
    ( DataOB(_idUpdate, pAsk, pBid, midP, wgmidP, cummAsks, cummBids, dataOLS, regOLS),
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
  putStrLn "Mid-price:"
  print $ MyLib.midP df_ob
  putStrLn "Weighted mid-price:"
  print $ MyLib.wgmidP df_ob
  putStrLn "CJP martingale:"
  print $ (exp . snd) (MyLib.regOLS df_ob)
  putStrLn "Bid-Ask Spread in ticks:"
  print $ (MyLib.pBid df_ob - MyLib.pAsk df_ob ) / 0.0001
  plot X11 $ zip (map snd $ MyLib.dataOLS df_ob) (map fst $ MyLib.dataOLS df_ob)
  putStrLn "Press \'CTRL + C \' to stop."

-- selectTicker :: IO Char -> IO Char -> IO URL
-- selectTicker do = 
--   putStrLn "Select Ticker:"
--   putStrLn "Enter 1 for ADAUSDT;"
--   putStrLn "Enter 2 for ADABRL;"
--   putStrLn "Enter 3 for BTCUSDT;"
--   putStrLn "Enter 4 for BTCBRL."

-- >>= bind
--(>>=) :: Monad m => m a -> (a -> m b) -> m b
--(>>) :: m a -> m b -> m b
--return :: a -> m a
-- left
-- return a >>= k = k a
-- right
-- m >>= return = m
-- associativity
-- m >>= (\x -> k x >>= h) = (m >>= k) >>= h

--fmap :: (a -> b) -> f a -> f b
--pure :: a -> f a
--(<*>) :: f (a -> b) -> f a -> f b

-- u :: MyLib.URL
-- u = (MyLib.constructUrl (Ticker "ADAUSDT") (Depth 10))

--b = sortBy (flip compare `on` fst) $ Utils.ordersToDouble 

--a = sortBy (compare `on` fst) $ Utils.ordersToDouble 

