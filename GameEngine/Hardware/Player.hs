-- Player.hs
-- Player and Nation data types and logic

module Hardware.Player 
  ( Player(..)
  , newPlayerIncome
  , newPlayerBalance
  , newPlayerUnits
  , collectIncome
  , buyUnits
  , placeUnits
  ) where

import Hardware.Units
import Hardware.Zone



-- | Player state consists of immutable nation and mutable income,
-- balance, and purchased-yet-unplaced units.
data Player = Player
            { playerNation  :: Nation
            , playerIncome  :: Int
            , playerBalance :: Int
            , unitsToPlace  :: Units
            } deriving(Show)

-- | Updates player income. The input income is expected to be
-- positive, as all valid incomes are.
newPlayerIncome :: Int -> Player -> Player
newPlayerIncome newIncome (Player n _ b u) = Player n newIncome b u

-- | Updates player balance. Balance's also must be positive.
newPlayerBalance :: Int -> Player -> Player
newPlayerBalance newBal (Player n i _ u) = Player n i newBal u

-- | Updates player units.
newPlayerUnits :: Units -> Player -> Player
newPlayerUnits units (Player n i b _) = Player n i b units

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
buyUnits (Player n i b _) newUnits = Player n i b' newUnits
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