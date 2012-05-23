-- Hardware type definitions and logic

module Hardware
  ( Game(Game)
  , Player(..)
  , Nation(..)
  , ally
  , axis
  , Units(..)
  , Board(..)
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

import UnitTypes as UT
import Data.Map as M

data Game = Game [Player] Board

data Player = Player
            { nation        :: Nation
            , playerIncome  :: Int
            , playerBalance :: Int
            , unitsToPlace  :: Units
            }

newPlayerIncome :: Player -> Int -> Player
newPlayerIncome (Player n _ b u) newIncome = Player n newIncome b u

newPlayerBalance :: Player -> Int -> Player
newPlayerBalance (Player n i _ u) newBal = Player n i newBal u

buyUnits :: Player -> Units -> Player
buyUnits (Player n i b _) newUnits = Player n i b newUnits

data Nation = Russia
            | Germany
            | Britain
            | Japan
            | America
            deriving(Eq, Show, Read)

ally :: Nation -> Bool
ally Russia  = True
ally Britain = True
ally America = True
ally _       = False

axis :: Nation -> Bool
axis Germany = True
axis Japan   = True
axis _       = False

data Units = Units
           { infantry    :: Int
           , artillery   :: Int
           , armors      :: Int
           , antiair     :: Int
           , factories   :: Int
           , fighters    :: Int
           , bombers     :: Int
           , battleships :: Int
           , carriers    :: Int
           , transports  :: Int
           , submarines  :: Int
           } deriving(Show)

data Board = Board (Map String Zone)

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