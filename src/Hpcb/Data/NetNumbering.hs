{-# LANGUAGE FlexibleInstances #-}
module Hpcb.Data.NetNumbering (
  listOfNets,
  netsMap,
  numberNets
) where

import Hpcb.Data.Net
import Hpcb.Data.FpElement
import Hpcb.Data.Circuit
import Hpcb.Data.Footprint
import Hpcb.Data.Segment
import Hpcb.SExpr
import qualified Data.Map as Map
import Control.Lens


-- | Returns the list of nets in a circuit
listOfNets :: Circuit -> [Net]
listOfNets = toListOf (_footprints . traverse . _fpContent . _fpElements . traverse . _pad . _net)

-- | Returns a map of net names to their number
netsMap :: Circuit -> Map.Map Net Int
netsMap c = Map.fromList $ zip (listOfNets c) [1..]

-- | Assigns its number to a Net
numberNet :: Map.Map Net Int -> Net -> Net
numberNet m (Net nn) = case Map.lookup (Net nn) m of
                          Nothing -> error $ "Error while looking up the net number of net " ++ show nn
                          Just n -> NumberedNet n nn
numberNet _ (NumberedNet n nn) = NumberedNet n nn

-- | Assigns its number to every net of the 'Circuit'
numberNets :: Circuit -> Circuit
numberNets c = c2
  where
    c1 = over (_footprints . traverse . _fpContent . _fpElements . traverse . _pad . _net) (numberNet (netsMap c)) c
    c2 = over (_segments . traverse . _segNet ) (numberNet nm) c1
    nm = netsMap c

instance Itemizable (Map.Map Net Int) where
  itemize m = Item "NetsMap" $ map f (Map.toList m')
    where
      f (k, v) = Item "net" [PInt v, PString $ show (netName k)]
      m' = Map.insert (Net "") 0 m
