{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module MyLib where

import Control.Monad ()

import Control.Concurrent ()
import Control.Lens ( (^.) )
import Data.Monoid ()
--import Data.Time.Clock (getCurrentTime)
import Data.Maybe ()

import Network.Wreq ( asJSON, get, responseBody )
import Data.Text (Text)
import Data.Aeson ( FromJSON )
import GHC.Generics ( Generic )

import Data.Function (on)
import Data.List (minimumBy, maximumBy, sortBy)
import Data.Ord (comparing)
import Utils ( ordersToDouble, minFst, maxFst, accQtd )
import SSC (linearRegression, calculateRSqr)

-- Types for defining the API.
--------------------------------------------------------------------------------
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

{-getLineTickerDepth :: IO String -> IO String -> [(Ticker, Depth)]
getLineTickerDepth = do
  putStrLn "Tickers:"
  putStrLn "1 for ADAUSDT"
  putStrLn "2 for CTSIUSDT"
  t <- getChar
  putStrLn "Depth:"
  d <- getChar (read :: String -> Int)
-}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- GET WITH JSON PARSER on RspOrderBook type
--------------------------------------------------------------------------------
data RspOrderBook = RspOrderBook {
  --respHeaders :: [(String, String)],
  lastUpdateId :: Int,
  bids :: [(String, String)],
  asks :: [(String, String)]
} deriving (Show, Generic)

instance FromJSON RspOrderBook

getOrderBook :: IO RspOrderBook
getOrderBook = do
  r <- asJSON =<< Network.Wreq.get (constructUrl (Ticker "CTSIUSDT") (Depth 20))
  pure (r ^. Network.Wreq.responseBody)
--------------------------------------------------------------------------------

-- DataOB: type for assembling data for estimating the SSC
--------------------------------------------------------------------------------
type ListDataOB = [DataOB]
data DataOB = DataOB {
  _time :: Double,
  _idUpdate :: Int,
  xAsks :: [(Double, Double)],
  xBids :: [(Double, Double)],
  cummAsks :: [(Double, Double)],
  cummBids :: [(Double, Double)],
  dataOLS :: [(Double, Double)],
  regOLS :: (Double, Double),
  cjpM :: Double,
  rSqr :: Double,
  pAsk :: Double,
  pBid :: Double,
  qAsk :: Double,
  qBid :: Double,
  imBal :: Double,
  midP :: Double,
  wgmidP :: Double
} deriving (Show, Generic)

buildOBData :: RspOrderBook -> DataOB
buildOBData rOB = let
  xbs = sortBy (flip compare `on` fst) $ Utils.ordersToDouble (MyLib.bids rOB)
  xas = sortBy (compare `on` fst) $ Utils.ordersToDouble (MyLib.asks rOB)
  cumbs = Utils.accQtd $ map (\x -> (fst x, snd x/(-1000))) xbs
  cumas = Utils.accQtd $ map (\x -> (fst x, snd x/1000)) xas
  dataols = sortBy (compare `on` fst) $ map (\x -> (fst x, snd x)) cumbs ++ cumas
  regols = linearRegression (map snd dataols) (map (log . fst) dataols)
  rsqr = calculateRSqr regols (map snd dataols) (map (log . fst) dataols)
  cjpm = (exp . snd) regols
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
    dataOLS = dataols,
    regOLS = regols,
    cjpM = cjpm,
    rSqr = rsqr,
    pBid = pbid,
    pAsk = pask,
    qBid = qbid,
    qAsk = qask,
    imBal = imb,
    midP = (pask + pbid) / 2,
    wgmidP = pbid * (1 - imb) + pask * imb
  }


