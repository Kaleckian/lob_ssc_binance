{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO
import Control.Monad ( forever )

--import Data.Time.Clock (getCurrentTime)

import Data.Function (on)
import Data.List (minimumBy, maximumBy, sortBy)
import Data.Ord (comparing)

import MyLib
  ( DataOB(
    _idUpdate,
    pAsk, pBid, midP, wgmidP, regOLS, rSqr, 
    dataOLS, xAsks, xBids, cummAsks, cummBids),
    Depth(Depth),
    Ticker(Ticker),
    ListDataOB,
    URL,
    constructUrl,
    getOrderBook,
    buildOBData )

import SSC
import CallPy ( initData, argData, livePlots)
import TestCSV
import Control.Concurrent (forkIO, threadDelay)
import Utils (x,y,tup)

main :: IO ()
--main = forever $ do 
main = do
  
  CallPy.initData
  --forkIO $ CallPy.livePlots

  forever $ do
    ob <- MyLib.getOrderBook 
    let df_ob = MyLib.buildOBData ob
    CallPy.argData df_ob
    putStrLn "Press \'CTRL + C \' to stop."

  {-
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

  putStrLn "R-Squared:"
  print $ MyLib.rSqr df_ob

  putStrLn "OLS Parameters"
  print $ MyLib.regOLS df_ob

  putStrLn "xBids"
  print $ MyLib.xBids df_ob

  putStrLn "xAsks"
  print $ MyLib.xAsks df_ob
  -}
  

{-
main = do

  CallPy.staticPy
  putStrLn "Press \'CTRL + C \' to stop."

main2 = do
  forkIO $ do {
    putStrLn "fork1"
  }

  forkIO $ do {
    threadDelay (1*10^6);
    putStr("1 sec")
  }
  putStrLn "De fora"
-}
-- (=<<) :: Monad m => (a -> m b) -> m a -> m b
-- (>>=) :: Monad m => m a -> (a -> m b) -> m b
-- (>>) :: Monad m => m a -> m b -> m b
-- return :: Monad m => a -> m a
-- pure :: Applicative f => a -> f a
-- print :: Show a => a -> IO ()
-- append/concatenate anything (including functions) (works with functions)
-- (<>) :: Semigroup a => a -> a -> a
-- mconcat :: Monoid a => [a] -> a

-- getOrderBook :: IO RspOrderBook
-- buildOBData :: RspOrderBook -> DataOB
-- putStrLn :: String -> IO ()
--main :: IO ()
--main02 = do 
  