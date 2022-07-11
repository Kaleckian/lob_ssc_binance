{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module MyLib where

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


