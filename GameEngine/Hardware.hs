-- Hardware type definitions and logic

module Hardware where

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