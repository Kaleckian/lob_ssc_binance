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


-- calculateRSqr :: (Double, Double) -> [Double] -> [Double] -> a
-- calculateRSqr _ [] [] = 0
-- calculateRSqr (b, a) x y = 1 - (ssr)/(sst) where
--   yhat = map (\xi -> a + b * xi) x
--   yavg = average y
--   numy = zipWith (-) y yhat 
--   deny = map . (\yi -> y - yavg) y
--   ssr = foldr1 (+) $ map (^2) numy
--   sst = foldr1 (+) $ map (^2) deny  


-- movingWindow :: [Double] -> Int -> [Double]
-- movingWindow xs windowSize
--   | windowSize < 1 = error "Cannot have non-positive window size."
--   | windowSize > length xs = []
--   | otherwise = map (fromIntegral windowSize) movingLs
--   where
--     movingLs = (take windowSize xs) ++ (drop windowSize xs)
