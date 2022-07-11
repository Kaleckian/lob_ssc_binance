module SSC where

average :: (Fractional a, Foldable t) => t a -> a
average xs = sum xs / fromIntegral(length xs)

covariance :: Fractional a => [a] -> [a] -> a
covariance xs ys = average $ zipWith f xs ys where
  f = \xi yi -> (xi - average xs) * (yi - average ys)

variance :: Fractional a => [a] -> a
variance xs = covariance xs xs

linearRegression :: [Double] -> [Double] -> (Double, Double)
linearRegression xs ys = (gradient, intercept)
  where
    gradient = covariance xs ys / variance xs
    intercept = average ys - gradient * average xs


{-
movingWindow :: [Double] -> Int -> [Double]
movingWindow xs windowSize
  | windowSize < 1 = error "Cannot have non-positive window size."
  | windowSize > length xs = []
  | otherwise = map (fromIntegral windowSize) movingLs
  where
    movingLs = (take windowSize xs) ++ (drop windowSize xs)
-}