-- Zone.hs
-- Zone, AllUnits, and Nation data types

module Hardware.Zone 
  ( Zone(..)
  , newZoneOwner
  , newZoneUnits
  , AllUnits
  , allEmptyUnits
  , getNationsUnits
  , insertNationsUnits
  , Nation(..)
  , ally
  , axis
  ) where

import Data.Map as M
import Data.Maybe

import Hardware.Units



-- | Data type for zones on the game board.
data Zone = Zone
          { name  :: String
          , value :: Int
          , owner :: Nation
          , color :: Nation -- original owner
          , zoneUnits :: AllUnits
          , adjacentZones :: [Zone]
          } deriving(Show,Read)

newZoneOwner :: Nation -> Zone -> Zone
newZoneOwner newOwner (Zone n v _ c zu az) =
  Zone n v newOwner c zu az

newZoneUnits :: AllUnits -> Zone -> Zone
newZoneUnits newUnits (Zone n v o c _ az) =
  Zone n v o c newUnits az



-- | Data type used to store all the nations' units in a zone.
data AllUnits = AllUnits (Map Nation Units)
                deriving(Show,Read)

allEmptyUnits :: AllUnits
allEmptyUnits = AllUnits $
  M.fromList [ (Russia, noUnits)
             , (Germany, noUnits)
             , (Britain, noUnits)
             , (Japan, noUnits)
             , (America, noUnits)
             ]

getNationsUnits :: Nation -> AllUnits -> Units
getNationsUnits nation (AllUnits map) =
  fromMaybe noUnits $ M.lookup nation map

insertNationsUnits :: Nation -> Units -> AllUnits -> AllUnits
insertNationsUnits nation units (AllUnits map) =
  AllUnits $ M.insert nation units map



-- | Data types for the file available nations in the game.
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