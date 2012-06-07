-- Turn.hs
-- Turn data type stores turn state information.

module Rules.Turn where

import Hardware.Player
import Hardware.Zone

data Turn = Turn Phase Player
            deriving(Show,Read,Eq)

-- | Determines the next turn object from the given one.
nextTurn :: Turn -> Turn
nextTurn (Turn phase player) =
  let phase' = nextPhase phase
  in case phase' of
       Just p  -> Turn p player
       Nothing -> Turn Research $ nextPlayer player

-- | Determines the next player from the given player.
nextPlayer :: Player -> Player
nextPlayer = undefined

-- | Order in which each player takes its turn.
turnOrder :: [Nation]
turnOrder = cycle [Russia,Germany,Britain,Japan,America]

data Phase = Research
           | PurchaseUnits
           | CombatMovement
           | Combat
           | NoncombatMovement
           | PlaceNewUnits
           | CollectIncome
             deriving(Show,Read,Eq,Ord)

nextPhase :: Phase -> Maybe Phase
nextPhase Research = Just PurchaseUnits
nextPhase PurchaseUnits = Just CombatMovement
nextPhase CombatMovement = Just Combat
nextPhase Combat = Just NoncombatMovement
nextPhase NoncombatMovement = Just PlaceNewUnits
nextPhase CollectIncome = Nothing