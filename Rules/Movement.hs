-- Movement.hs
-- Rules for movement across the board.

module Rules.Movement where

import Data.List as L

import Hardware



-- | Functions for calculating the distance between two named zones
-- by air, land, or sea.
airDist, landDist, seaDist ::
  Board -> Player -> String -> String -> Infinite

  

-- | Returns the maximum mobility of a group of Units.
maxMobility :: Player -> Units -> Int
maxMobility player units
  | factories units > 0
    = 0
  | infantry units > 0 ||
    artillery units > 0 ||
    antiairs units > 0
    = 1
  | armors units > 0 ||
    battleships units > 0 ||
    destroyers units > 0 ||
    carriers units > 0 ||
    transports units > 0 ||
    submarines units > 0
    = 2
  | fighters units > 0
    = 4 + longRange player
  | bombers units > 0
    = 6 + longRange player
  | otherwise
    = 0
  where longRange :: Player -> Int
        longRange player = if LongRangeAircraft `isKnownBy` player
                           then 2
                           else 0



data Infinite = Finite Int
              | Infinity
                deriving(Show,Read,Eq,Ord)

finite :: Int -> Infinite -> Int
finite _ (Finite x) = x
finite x Infinity   = x