module Hpcb.Data.Circuit(
  Circuit(..),
  _footprints,
  _graphics,
  _segments
) where

import Hpcb.Data.Action
import Hpcb.Data.Footprint
import Hpcb.Data.Graphic
import Hpcb.Data.Segment
import Hpcb.SExpr
import Control.Lens hiding (transform)

-- | Main datatype, which is used to combine circuits together.
data Circuit = Circuit {
  getFootprints :: [Footprint],
  getGraphics :: [Graphic],
  getSegments :: [Segment]
} deriving Show

instance Monoid Circuit where
  mempty = Circuit [] [] []
  (Circuit f1 g1 s1) `mappend` (Circuit f2 g2 s2) = Circuit (f1 ++ f2) (g1 ++ g2) (s1 ++ s2)

instance Itemizable Circuit where
  itemize (Circuit f g s) = Item "kicad_pcb" $
    map itemize f ++ map itemize g ++ map itemize s

instance Transformable Circuit where
  transform m (Circuit f g s) = Circuit (map (transform m) f) (map (transform m) g) (map (transform m) s)

instance Parameterized Circuit where
  layer l (Circuit f g s) = Circuit (map (layer l) f) (map (layer l) g) (map (layer l) s)
  layers ls (Circuit f g s) = Circuit (map (layers ls) f) (map (layers ls) g) (map (layers ls) s)
  width w (Circuit f g s) = Circuit (map (width w) f) (map (width w) g) (map (width w) s)
  effects e (Circuit f g s) = Circuit (map (effects e) f) (map (effects e) g) (map (effects e) s)

-- Lenses

-- | Lens for footprints in a circuit
_footprints :: Lens' Circuit [Footprint]
_footprints = lens getFootprints (\circuit footprints -> circuit {getFootprints = footprints})

-- | Lens for graphics in a circuit
_graphics :: Lens' Circuit [Graphic]
_graphics = lens getGraphics (\circuit graphics -> circuit {getGraphics = graphics})

-- | Lens for segments in a circuit
_segments :: Lens' Circuit [Segment]
_segments = lens getSegments (\circuit segments -> circuit {getSegments = segments})
