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

x = [1.0..10.0]
y = [0.3906373, 0.6805038, 2.4701434, 4.1830330, 2.6120854, 5.0938693, 4.5021476, 6.1902221, 7.2997985, 7.4370719]

calculateRSqr :: (Double, Double) -> [Double] -> [Double] -> Double
calculateRSqr _ [] [] = 0
calculateRSqr (b, a) x y = 1 - (ssr)/(sst) where
  yhat = map (\xi -> a + b * xi) x
  yavg = average y
  numy = zipWith (-) y yhat 
  deny = map (\yi -> yi - yavg) y
  ssr = foldr1 (+) $ map (^2) numy
  sst = foldr1 (+) $ map (^2) deny  

-- movingWindow :: [Double] -> Int -> [Double]
-- movingWindow xs windowSize
--   | windowSize < 1 = error "Cannot have non-positive window size."
--   | windowSize > length xs = []
--   | otherwise = map (fromIntegral windowSize) movingLs
--   where
--     movingLs = (take windowSize xs) ++ (drop windowSize xs)
