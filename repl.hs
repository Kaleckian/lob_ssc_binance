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
--import Data.Typeable
--import Data.ByteStringmain


import Network.Wreq
import Data.Text (Text)
import Data.Aeson
import GHC.Generics

import Data.Function (on)
import Data.List (minimumBy, maximumBy, sortBy)
import Data.Ord (comparing)
import qualified Utils --(ordersToDouble, orderToSSCData, a', b')
import qualified MyLib --(ordersToDouble, orderToSSCData, a', b')

main :: IO ()
main = forever $ do
  -- lots of stuff
  ob <- getOrderBook 
  let df_ob = buildOBData ob 
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
  print $ show (_idUpdate df_ob)
  putStrLn "The ask-price:"
  print $ pAsk $ df_ob
  putStrLn "The bid-price:"
  print $ pBid $ df_ob
  putStrLn "The mid-price is:"
  print $ midP $ df_ob
  putStrLn "The weighted mid-price is:"
  print $ wgmidP $ df_ob
  putStrLn "Press \'CTRL + C \' to stop."

data DataOB = DataOB {
  _time :: Double,
  _idUpdate :: Int,
  xAsks :: [(Double, Double)],
  xBids :: [(Double, Double)],
  cummAsks :: [(Double, Double)],
  cummBids :: [(Double, Double)],
  pAsk :: Double,
  pBid :: Double,
  qAsk :: Double,
  qBid :: Double,
  imBal :: Double,
  midP :: Double,
  wgmidP :: Double
} deriving (Show, Generic)

type ListDataOB = [DataOB]

--sortBy (comparing $ length . snd)
buildOBData :: RspOrderBook -> DataOB
buildOBData rOB = let  
  xbs = sortBy (flip compare `on` fst) $ Utils.ordersToDouble (Main.bids rOB)
  xas = sortBy (compare `on` fst) $ Utils.ordersToDouble (Main.asks rOB)
  cumbs = Utils.accQtd xbs
  cumas = Utils.accQtd xas
  pask = fst $ Utils.minFst xas
  qask = snd $ Utils.minFst xas
  pbid = fst $ Utils.maxFst xbs
  qbid = snd $ Utils.maxFst xbs
  imb = qbid/(qbid + qask)
  in DataOB{
    _time = 1.0,
    _idUpdate = lastUpdateId rOB,
    xBids = xbs,
    xAsks = xas,
    cummBids = cumbs,
    cummAsks = cumas,
    pBid = pbid,
    pAsk = pask,
    qBid = qbid,
    qAsk = qask,
    imBal = imb,
    midP = (pask + pbid) / 2,
    wgmidP = pbid * (1 - imb) + pask * imb
  }


data RspOrderBook = RspOrderBook {
  --respHeaders :: [(String, String)],
  lastUpdateId :: Int,
  bids :: [(String, String)],
  asks :: [(String, String)]
} deriving (Show, Generic)

instance FromJSON RspOrderBook

getOrderBook :: IO (RspOrderBook)
getOrderBook = do 
  r <- asJSON =<< Network.Wreq.get (constructUrl (Ticker "ADAUSDT") (Depth 10))
  pure (r ^. Network.Wreq.responseBody)

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

newtype Ticker = Ticker {ticker :: String} deriving (Show)

newtype Depth = Depth {depth :: Int}
instance Show Depth where
  show (Depth d) = show d

type URL = String

constructUrl :: Ticker -> Depth -> URL
constructUrl t d = baseurl ++ 
  "limit=" ++ show(depth d) ++ "&" ++ 
  "symbol=" ++ ticker t where 
    baseurl = "https://api.binance.com/api/v3/depth?"

u = (constructUrl (Ticker "ADAUSDT") (Depth 10))

a = [("0.45550000","20777.60000000"),("0.45560000","18933.10000000"),("0.45570000","39724.80000000"),("0.45580000","114215.20000000"),("0.45590000","106827.40000000"),("0.45600000","80535.00000000"),("0.45610000","47085.80000000"),("0.45620000","122613.90000000"),("0.45630000","39021.30000000"),("0.45640000","100232.80000000")]
b = [("0.45540000","21199.30000000"),("0.45530000","36264.90000000"),("0.45520000","58507.40000000"),("0.45510000","60566.40000000"),("0.45500000","67635.80000000"),("0.45490000","26048.40000000"),("0.45480000","68775.80000000"),("0.45470000","72475.50000000"),("0.45460000","150091.70000000"),("0.45450000","15103.80000000")]

b' = sortBy (flip compare `on` fst) $ Utils.ordersToDouble b
a' = sortBy (compare `on` fst) $ Utils.ordersToDouble a
  