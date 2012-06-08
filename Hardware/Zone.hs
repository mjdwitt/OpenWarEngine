-- Zone.hs
-- Zone, AllUnits, and Nation data types

module Hardware.Zone 
  ( Zone(..)
  , zoneIsNamed
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
          , water :: Bool
          , owner :: Nation
          , color :: Nation -- original owner
          , zoneUnits :: AllUnits
          , adjacentZones :: [String]
          } deriving(Show,Read)

-- | Tests if a given zone has the given name.
zoneIsNamed :: Zone -> String -> Bool
zoneIsNamed z n = name z == n

newZoneOwner :: Nation -> Zone -> Zone
newZoneOwner newOwner (Zone n v w _ c zu az) =
  Zone n v w newOwner c zu az

newZoneUnits :: AllUnits -> Zone -> Zone
newZoneUnits newUnits (Zone n v w o c _ az) =
  Zone n v w o c newUnits az



-- | Data type used to store all the nations' units in a zone.
data AllUnits = AllUnits
  { rUnits :: Units
  , gUnits :: Units
  , bUnits :: Units
  , jUnits :: Units
  , aUnits :: Units
  } deriving(Show)

allEmptyUnits :: AllUnits
allEmptyUnits = AllUnits noUnits noUnits noUnits noUnits noUnits

-- | Returns the given nation's units from an AllUnits object.
getNationsUnits :: Nation -> AllUnits -> Units
getNationsUnits Russia  = rUnits
getNationsUnits Germany = gUnits
getNationsUnits Britain = bUnits
getNationsUnits Japan   = jUnits
getNationsUnits America = aUnits

-- | Overwrites the given nations units with the supplied units
-- in the give AllUnits.
insertNationsUnits :: Nation -> Units -> AllUnits -> AllUnits
insertNationsUnits n u (AllUnits r g b j a) =
  go n
  where go Russia  = AllUnits u g b j a
        go Germany = AllUnits r u b j a
        go Britain = AllUnits r g u j a
        go Japan   = AllUnits r g b u a
        go America = AllUnits r g b j u



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