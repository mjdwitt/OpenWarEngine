-- Board.hs
-- Board logic

module Board where

import Data.Map as M
import Data.Maybe

import Units
import Zone



-- | The board data type containing all of the zones.
data Board = Board (Map Name Zone)
             deriving(Show,Read)

type Name = String

-- | Get a zone from a given board.
lookupZone :: String -> Board -> Maybe Zone
lookupZone name (Board map) = M.lookup name map

-- | Insert a new zone into a board, replacing the old zone.
insertZone :: String -> Zone -> Board -> Board
insertZone name zone (Board map) = Board $ M.insert name zone map