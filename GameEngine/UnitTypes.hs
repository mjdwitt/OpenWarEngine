-- Enumerations of stats for each type of unit

module UnitTypes
  ( UnitType
  , cost
  , movement
  , attack
  , defense
  , structure
  , infantry
  , artillery
  , armor
  , antiair
  , factory
  , battleship
  , carrier
  , transport
  , submarine
  ) where

data UnitType = UnitType
              { cost      :: Int
              , movement  :: Int
              , attack    :: Int
              , defense   :: Int
              , structure :: Bool
              } deriving(Eq, Show)

infantry   = UnitType  3 1 1 2 False
artillery  = UnitType  4 1 2 2 False
armor      = UnitType  5 2 3 2 False
antiair    = UnitType  5 1 0 0 True
factory    = UnitType 15 0 0 0 True
fighter    = UnitType 12 4 3 4 False
bomber     = UnitType 15 6 5 1 False
battleship = UnitType 24 2 4 4 False
carrier    = UnitType 18 2 1 3 False
transport  = UnitType  8 2 0 1 False
submarine  = UnitType  8 2 2 2 False