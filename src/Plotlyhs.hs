{-# LANGUAGE OverloadedStrings #-}

module Plotlyhs where

import Lucid
import Lucid.Html5
import Graphics.Plotly
import Graphics.Plotly.Lucid
import Lens.Micro
import Data.Text (Text)
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as T
import MyLib ( DataOB )
{-
hbarData :: [(Text, Double)]
hbarData = [("Simon", 14.5), ("Joe", 18.9), ("Dorothy", 16.2)]

-- hbarData :: [(Double, Double)] -> [(Text, Double)]
-- hbarData = f a where
--   f = map (\a -> (show . fst a, snd a))
ploths = do
plotly "div7" 
    [hbars (aes & y .~ fst
                & x .~ snd)
          hbarData]
    & layout . margin ?~ thinMargins
    & layout . height ?~ 300
-}