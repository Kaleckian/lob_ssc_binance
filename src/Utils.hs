{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE BangPatterns #-}

module Utils where
import Data.Function (on)
import Data.List (minimumBy, maximumBy, sortBy)
import Data.Ord (comparing)

mapTuple :: (a -> b) -> (a, a) -> (b, b)
mapTuple f (a1, a2) = (f a1, f a2)

ordersToDouble :: [(String, String)] -> [(Double, Double)]
ordersToDouble a = map tupDouble a where
  tupDouble = (\x -> (read (fst x) :: Double, read (snd x) :: Double))

minFst :: Ord a => [(a, b)] -> (a, b)
minFst xs = minimumBy (comparing fst) xs

maxFst :: Ord a => [(a, b)] -> (a, b)
maxFst xs = maximumBy (comparing fst) xs

accQtd :: [(Double, Double)] -> [(Double, Double)]
accQtd [] = []
accQtd xs = zip ps qs where
  ps = map fst xs
  qs = scanl1 (+) (map snd xs)