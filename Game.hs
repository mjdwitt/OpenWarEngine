-- Game logic engine

module Game where

import Data.Map as M
import Data.Maybe

import Hardware
import Rules

-- | Game state information is tracked as a list of the player
-- states, the state of the board, and the current turn state.
data Game = Game
          { ru :: Player
          , de :: Player
          , uk :: Player
          , jp :: Player
          , us :: Player
          , board :: Board
          } deriving(Show,Read)

-- Some modifiers for Game objects
newRu ru' (Game _ de uk jp us b)    = Game ru' de uk jp us b
newDe de' (Game ru _ uk jp us b)    = Game ru de' uk jp us b
newUk uk' (Game ru de _ jp us b)    = Game ru de uk' jp us b
newJp jp' (Game ru de uk _ us b)    = Game ru de uk jp' us b
newUs us' (Game ru de uk jp _ b)    = Game ru de uk jp us' b
newBoard b' (Game ru de uk jp us _) = Game ru de uk jp us b'