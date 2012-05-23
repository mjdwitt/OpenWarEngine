-- Hardware type definitions and logic

module Hardware
  ( Game(Game)
  , Player(..)
  , Nation(..)
  , ally
  , axis
  , Units(..)
  , Board
  , Zone
  , zoneName
  , zoneValue
  , zoneOwner
  , newZoneOwner
  , zoneColor
  , adjacentZones
  , zoneUnits
  , newZoneUnits
  ) where

import Data.Map as M

--import Territories as T
import UnitTypes as U

-- | Game state information is tracked as a list of the players'
-- states and the state of the board.
data Game = Game [Player] Board

-- | Player state consists of immutable nation and mutable income,
-- balance, and purchased-yet-unplaced units.
data Player = Player
            { nation        :: Nation
            , playerIncome  :: Int
            , playerBalance :: Int
            , unitsToPlace  :: Units
            } deriving(Show)

-- | Updates player income. The input income is expected to be
-- positive, as all valid incomes are.
newPlayerIncome :: Player -> Int -> Player
newPlayerIncome (Player n _ b u) newIncome = Player n newIncome b u

-- | Updates player balance. Balance's also must be positive.
newPlayerBalance :: Player -> Int -> Player
newPlayerBalance (Player n i _ u) newBal = Player n i newBal u

-- | Updates player purchased units and subtracts the cost from
-- their blance. The total cost of the purchased units is expected
-- to be less than the player's balance.
buyUnits :: Player -> Units -> Player
buyUnits (Player n i b _) newUnits = Player n i b' newUnits
  where b' = b - totalUnitsCost newUnits
        totalUnitsCost :: Units -> Int
        totalUnitsCost units =
          (U.cost U.infantry * infantry units) +
          (U.cost U.artillery * artillery units) +
          (U.cost U.armor * armors units) +
          (U.cost U.antiair * antiair units) +
          (U.cost U.factory * factories units) +
          (U.cost U.fighter * fighters units) +
          (U.cost U.bomber * bombers units) +
          (U.cost U.battleship * battleships units) +
          (U.cost U.destroyer * destroyers units) +
          (U.cost U.carrier * carriers units) +
          (U.cost U.transport * transports units) +
          (U.cost U.submarine * submarines units)

data Nation = Russia
            | Germany
            | Britain
            | Japan
            | America
            deriving(Eq, Show, Read)

-- | 'ally' and 'axis' test if a nation is on the respective team.
ally :: Nation -> Bool
ally Russia  = True
ally Britain = True
ally America = True
ally _       = False

axis :: Nation -> Bool
axis Germany = True
axis Japan   = True
axis _       = False

-- | A record counting the number of each type of unit.
data Units = Units
           { infantry    :: Int
           , artillery   :: Int
           , armors      :: Int
           , antiair     :: Int
           , factories   :: Int
           , fighters    :: Int
           , bombers     :: Int
           , battleships :: Int
           , destroyers  :: Int
           , carriers    :: Int
           , transports  :: Int
           , submarines  :: Int
           } deriving(Show)

type Board = Map String Zone

data Zone = Zone
          { zoneName  :: String
          , zoneValue :: Int
          , zoneOwner :: Nation
          , zoneColor :: Nation
          , adjacentZones :: [String]
          , zoneUnits :: Map Nation Units
          } deriving(Show)

newZoneOwner :: Zone -> Nation -> Zone
newZoneOwner (Zone n v _ c a u) newOwner = Zone n v newOwner c a u

newZoneUnits :: Zone -> Map Nation Units -> Zone
newZoneUnits (Zone n v o c a _) newUnits = Zone n v o c a newUnits