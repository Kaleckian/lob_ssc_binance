{-# LANGUAGE OverloadedStrings #-}

module SSC where

average xs = sum xs / fromIntegral(length xs)

covariance xs ys = average $ zipWith f xs ys where 
  f = (\xi yi -> (xi - average xs) * (yi - average ys))

variance xs = covariance xs xs

linearRegression :: [Double] -> [Double] -> (Double, Double)
linearRegression xs ys = (gradient, intercept)
  where
    gradient = covariance xs ys / variance xs
    intercept = (average ys) - gradient * (average xs)