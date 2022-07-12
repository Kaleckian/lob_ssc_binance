module Vega where

import           Graphics.Vega.VegaLite

mainVega = do
  toHtmlFile "myplot.html" $ toVegaLite
  [ dataFromUrl "rows.tsv" [TSV], mark Bar [MTooltip TTEncoding], 
    enc [], height 600, width 400]
    
  where enc = encoding
    . position X [ PName "date", PmType Ordinal]
    . position Y [ PName "joy", PmType Quantitative]
    . color [MName "activity", MmType Nominal]