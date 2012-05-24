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
          , turn :: Turn
          } deriving(Show,Read)

-- Some modifiers for Game objects
newRu ru' (Game _ de uk jp us b t)    = Game ru' de uk jp us b t
newDe de' (Game ru _ uk jp us b t)    = Game ru de' uk jp us b t
newUk uk' (Game ru de _ jp us b t)    = Game ru de uk' jp us b t
newJp jp' (Game ru de uk _ us b t)    = Game ru de uk jp' us b t
newUs us' (Game ru de uk jp _ b t)    = Game ru de uk jp us' b t
newBoard b' (Game ru de uk jp us _ t) = Game ru de uk jp us b' t
newTurn t' (Game ru de uk jp us b _)  = Game ru de uk jp us b t'