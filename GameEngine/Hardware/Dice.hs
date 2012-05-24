-- Dice.hs
-- Logic for rolling dice in IO loops.

module Hardware.Dice
  ( rollN
  ) where

import Numeric.Probability.Game.Event(makeEvent)
import Numeric.Probability.Game.Dice(DieRoll, roll)
import Control.Monad(replicateM)

-- | A six-sided die for rolling.
d6 = makeEvent [1..6] :: DieRoll

-- | A wrapper of the imported D.roll, as shown on authors site.
rollN n = replicateM n (roll d6)