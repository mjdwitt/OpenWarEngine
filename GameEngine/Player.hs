-- Player.hs
-- Player and Nation data types and logic

module Player where

import Units
import Board

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
newPlayerIncome :: Player -> Int -> Player
newPlayerIncome (Player n _ b u) newIncome = Player n newIncome b u

-- | Updates player balance. Balance's also must be positive.
newPlayerBalance :: Player -> Int -> Player
newPlayerBalance (Player n i _ u) newBal = Player n i newBal u

-- | Collects the player's income and adds it to their balance.
collectIncome :: Player -> Player
collectIncome player =
  newPlayerBalance player (income + balance)
    where income = playerIncome player
          balance = playerBalance player

-- | Updates player units.
newPlayerUnits :: Player -> Units -> Player
newPlayerUnits (Player n i b _) units = Player n i b units

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
      mzu = M.lookup pn (zoneUnits zone)
      zu = fromMaybe noUnits mzu
      pu' = pu .-. units
      zu' = zu .+. units
  in ( newPlayerUnits player pu'
     , newZoneUnits zone $ insert pn zu' $ zoneUnits zone
     )



-- | Data types for the five available nations in the game.
data Nation = Russia
            | Germany
            | Britain
            | Japan
            | America
            deriving(Eq, Ord, Show, Read)

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