{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad

import Control.Monad.Writer  
import Control.Monad.Reader
import Control.Monad.State

import Control.Concurrent
import Control.Lens
import Data.Monoid
import Data.Time.Clock (getCurrentTime)
import Data.Maybe

import Network.Wreq
import Data.Text (Text)
import Data.Aeson
import GHC.Generics

import Data.Function (on)
import Data.List (minimumBy, maximumBy, sortBy)
import Data.Ord (comparing)

import MyLib
    ( DataOB(_idUpdate, pAsk, pBid, midP, wgmidP),
      Depth(Depth),
      Ticker(Ticker),
      constructUrl,
      getOrderBook,
      buildOBData )
import Utils ( ordersToDouble )
--import qualified SSC

main :: IO ()
main = forever $ do
  -- lots of stuff
  ob <- MyLib.getOrderBook 
  let df_ob = MyLib.buildOBData ob 
  {-
  print $ _time df_ob
  print $ _idUpdate df_ob
  print $ xAsks df_ob
  print $ cummBids df_ob
  print $ pAsk df_ob
  print $ xBids df_ob
  print $ cummBids df_ob
  print $ pBid df_ob
  -}
  putStrLn "lastUpdateId:"
  print $ show (MyLib._idUpdate df_ob)
  putStrLn "The ask-price:"
  print $ MyLib.pAsk $ df_ob
  putStrLn "The bid-price:"
  print $ MyLib.pBid $ df_ob
  putStrLn "The mid-price:"
  print $ MyLib.midP $ df_ob
  putStrLn "The weighted mid-price:"
  print $ MyLib.wgmidP $ df_ob
  putStrLn "Press \'CTRL + C \' to stop."

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

u = (MyLib.constructUrl (Ticker "ADAUSDT") (Depth 10))

a = [("0.45550000","20777.60000000"),("0.45560000","18933.10000000"),("0.45570000","39724.80000000"),("0.45580000","114215.20000000"),("0.45590000","106827.40000000"),("0.45600000","80535.00000000"),("0.45610000","47085.80000000"),("0.45620000","122613.90000000"),("0.45630000","39021.30000000"),("0.45640000","100232.80000000")]
b = [("0.45540000","21199.30000000"),("0.45530000","36264.90000000"),("0.45520000","58507.40000000"),("0.45510000","60566.40000000"),("0.45500000","67635.80000000"),("0.45490000","26048.40000000"),("0.45480000","68775.80000000"),("0.45470000","72475.50000000"),("0.45460000","150091.70000000"),("0.45450000","15103.80000000")]

b' = sortBy (flip compare `on` fst) $ Utils.ordersToDouble b
a' = sortBy (compare `on` fst) $ Utils.ordersToDouble a
  