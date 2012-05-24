-- Player.hs
-- Player and Nation data types and logic

module Hardware.Player 
  ( Player(..)
  , playerIsNation
  , newPlayerIncome
  , newPlayerBalance
  , newPlayerUnits
  , collectIncome
  , buyUnits
  , placeUnits
  , Research(..)
  , attemptResearch
  , isKnownBy
  ) where

import System.IO.Unsafe

import Hardware.Dice
import Hardware.Units
import Hardware.Zone



-- | Player state consists of immutable nation and mutable income,
-- balance, and purchased-yet-unplaced units.
data Player = Player
            { playerNation   :: Nation
            , playerIncome   :: Int
            , playerBalance  :: Int
            , unitsToPlace   :: Units
            , researchedTech :: [Research]
            } deriving(Show,Read)

instance Eq Player where
  a == b = playerNation a == playerNation b

-- | Tests if a given player is a given nation.
playerIsNation :: Player -> Nation -> Bool
playerIsNation p n = playerNation p == n

-- | Updates player income. The input income is expected to be
-- positive, as all valid incomes are.
newPlayerIncome :: Int -> Player -> Player
newPlayerIncome newIncome (Player n _ b u r) =
  Player n newIncome b u r

-- | Updates player balance. Balance's also must be positive.
newPlayerBalance :: Int -> Player -> Player
newPlayerBalance newBal (Player n i _ u r) =
  Player n i newBal u r

-- | Updates player units.
newPlayerUnits :: Units -> Player -> Player
newPlayerUnits units (Player n i b _ r) = 
  Player n i b units r

newPlayerResearch :: Research -> Player -> Player
newPlayerResearch = undefined

-- | Collects the player's income and adds it to their balance.
collectIncome :: Player -> Player
collectIncome player =
  newPlayerBalance (income + balance) player
    where income = playerIncome player
          balance = playerBalance player

-- | Updates player purchased units and subtracts the cost from
-- their blance. The total cost of the purchased units is expected
-- to be less than the player's balance. This implies that the
-- client should check to make sure that it can afford the purchase.
buyUnits :: Player -> Units -> Player
buyUnits (Player n i b _ r) newUnits = Player n i b' newUnits r
  where b' = b - totalUnitsCost newUnits
        totalUnitsCost :: Units -> Int
        totalUnitsCost units =
          (unitCost infantryStats * infantry units) +
          (unitCost artilleryStats * artillery units) +
          (unitCost armorStats * armors units) +
          (unitCost antiairStats * antiairs units) +
          (unitCost factoryStats * factories units) +
          (unitCost fighterStats * fighters units) +
          (unitCost bomberStats * bombers units) +
          (unitCost battleshipStats * battleships units) +
          (unitCost destroyerStats * destroyers units) +
          (unitCost carrierStats * carriers units) +
          (unitCost transportStats * transports units) +
          (unitCost submarineStats * submarines units)

-- | Places some or all of the purchased units on the board.
placeUnits :: Player -> Units -> Zone -> (Player, Zone)
placeUnits player units zone =
  let pu = unitsToPlace player
      pn = playerNation player
      azu = zoneUnits zone
      zu = getNationsUnits pn azu
      pu' = pu .-. units
      zu' = zu .+. units
      azu' = insertNationsUnits pn zu' azu
  in ( newPlayerUnits pu' player
     , newZoneUnits azu' zone
     )



-- | Data types for each of the researchable techs.
data Research = JetPower
              | Rockets
              | SuperSubs
              | LongRangeAircraft
              | IndustrialTech
              | HeavyBombers
                deriving(Show,Read,Eq,Ord)

-- | Spends money on dice and attempts research with those dice.
attemptResearch :: Int -> Research -> Player -> Player
attemptResearch dice tech (Player n i b u r) =
  Player n i (b - 5*dice) u $ r ++ result
    where result = take 1 $ filter (== tech) rolls
          rolls = map intToTech
                . unsafePerformIO -- Okay, so it's not so functional.
                $ rollN dice

-- | Translates a number in [1..6] to a Research value.
intToTech :: Int -> Research
intToTech n | n == 1    = JetPower
            | n == 2    = Rockets
            | n == 3    = SuperSubs
            | n == 4    = LongRangeAircraft
            | n == 5    = IndustrialTech
            | n == 6    = HeavyBombers
            | otherwise = error "intToTech: int not in range"

-- | Test if a player has the given research completed.
isKnownBy :: Research -> Player -> Bool
tech `isKnownBy` player = tech `elem` researchedTech player