-- Board.hs
-- Board logic

module Hardware.Board where

import Data.Map as M
import Data.Maybe

import Hardware.Units
import Hardware.Zone



-- | The board data type containing all of the zones.
data Board = Board (Map Name Zone)
             deriving(Show,Read)

type Name = String

-- | Get a zone from a given board.
lookupZone :: String -> Board -> Maybe Zone
lookupZone name (Board map) = M.lookup name map

-- | Unsafe zone lookup.
unsafeLookupZone :: String -> Board -> Zone
unsafeLookupZone name board =
  case lookupZone name board of
    Just zone -> zone
    Nothing   -> error "unsafeLookupZone: no such zone"

-- | Insert a new zone into a board, replacing the old zone.
insertZone :: String -> Zone -> Board -> Board
insertZone name zone (Board map) = Board $ M.insert name zone map