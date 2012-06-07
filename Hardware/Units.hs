-- Units.hs
-- Logic for Units data types

module Hardware.Units
  ( Units(..)
  , noUnits
  , allInfantry
  , allArtillery
  , allArmors
  , allAntiairs
  , allFactories
  , allFighters
  , allBombers
  , allBattleships
  , allDestroyers
  , allCarriers
  , allTransports
  , allSubmarines
  , (.+.)
  , (.-.)
  , UnitType
  , unitCost
  , movement
  , attack
  , defense
  , capturable
  , infantryStats
  , artilleryStats
  , armorStats
  , antiairStats
  , factoryStats
  , fighterStats
  , bomberStats
  , battleshipStats
  , destroyerStats
  , carrierStats
  , transportStats
  , submarineStats
  ) where



-- | A record counting the number of each type of unit.
data Units = Units
           { infantry    :: Int
           , artillery   :: Int
           , armors      :: Int
           , antiairs    :: Int
           , factories   :: Int
           , fighters    :: Int
           , bombers     :: Int
           , battleships :: Int
           , destroyers  :: Int
           , carriers    :: Int
           , transports  :: Int
           , submarines  :: Int
           } deriving(Eq,Show,Read)

-- | The empty record of units.
noUnits          = Units 0 0 0 0 0 0 0 0 0 0 0 0

-- Some homogenous constructors.
allInfantry n    = Units n 0 0 0 0 0 0 0 0 0 0 0
allArtillery n   = Units 0 n 0 0 0 0 0 0 0 0 0 0
allArmors n      = Units 0 0 n 0 0 0 0 0 0 0 0 0
allAntiairs n    = Units 0 0 0 n 0 0 0 0 0 0 0 0
allFactories n   = Units 0 0 0 0 n 0 0 0 0 0 0 0
allFighters n    = Units 0 0 0 0 0 n 0 0 0 0 0 0
allBombers n     = Units 0 0 0 0 0 0 n 0 0 0 0 0
allBattleships n = Units 0 0 0 0 0 0 0 n 0 0 0 0
allDestroyers n  = Units 0 0 0 0 0 0 0 0 n 0 0 0
allCarriers n    = Units 0 0 0 0 0 0 0 0 0 n 0 0
allTransports n  = Units 0 0 0 0 0 0 0 0 0 0 n 0
allSubmarines n  = Units 0 0 0 0 0 0 0 0 0 0 0 n

-- Some combinators for Units records.

-- | @u '.+.' v@ adds the counts in the @Units@ records u and v.
(.+.) :: Units -> Units -> Units
(Units uinf uart uarm uant ufac ufig ubom ubat udes ucar utra usub) .+. (Units vinf vart varm vant vfac vfig vbom vbat vdes vcar vtra vsub) =
  Units (uinf + vinf) (uart + vart) (uarm + varm) (uant + vant) (ufac + vfac) (ufig + vfig) (ubom + vbom) (ubat + vbat) (udes + vdes) (ucar + vcar) (utra + vtra) (usub + vsub)

-- | @u '.-.' v@ subtracts the counts in v from u. All counts in v
-- must be lower than their counterparts in u.
(.-.) :: Units -> Units -> Units
(Units uinf uart uarm uant ufac ufig ubom ubat udes ucar utra usub) .-. (Units vinf vart varm vant vfac vfig vbom vbat vdes vcar vtra vsub) =
  Units (uinf - vinf) (uart - vart) (uarm - varm) (uant - vant) (ufac - vfac) (ufig - vfig) (ubom - vbom) (ubat - vbat) (udes - vdes) (ucar - vcar) (utra - vtra) (usub - vsub)



-- | A record of statistics for a particular unit type.
data UnitType = UnitType
              { unitCost   :: Int
              , movement   :: Int
              , attack     :: Int
              , defense    :: Int
              , capturable :: Bool
              } deriving(Eq, Show)

-- | Some enumerated statistics.
infantryStats   = UnitType  3 1 1 2 False
artilleryStats  = UnitType  4 1 2 2 False
armorStats      = UnitType  5 2 3 2 False
antiairStats    = UnitType  5 1 0 0 True
factoryStats    = UnitType 15 0 0 0 True
fighterStats    = UnitType 12 4 3 4 False
bomberStats     = UnitType 15 6 5 1 False
battleshipStats = UnitType 24 2 4 4 False
destroyerStats  = UnitType 12 2 3 3 False
carrierStats    = UnitType 18 2 1 3 False
transportStats  = UnitType  8 2 0 1 False
submarineStats  = UnitType  8 2 2 2 False