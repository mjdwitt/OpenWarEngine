-- Hardware type definitions and logic

module Game where

import Data.Map as M
import Data.Maybe

import Board
import Player
import Units
import Zone

-- | Game state information is tracked as a list of the players'
-- states and the state of the board.
data Game = Game
          { ru :: Player
          , de :: Player
          , uk :: Player
          , jp :: Player
          , us :: Player
          , board :: Board
          }

-- Some modifiers for Game objects
newRu ru' (Game _ de uk jp us board)    = Game ru' de uk jp us board
newDe de' (Game ru _ uk jp us board)    = Game ru de' uk jp us board
newUk uk' (Game ru de _ jp us board)    = Game ru de uk' jp us board
newJp jp' (Game ru de uk _ us board)    = Game ru de uk jp' us board
newUs us' (Game ru de uk jp _ board)    = Game ru de uk jp us' board
newBoard board' (Game ru de uk jp us _) = Game ru de uk jp us board'