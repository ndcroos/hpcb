module Hpcb.Functions (
  footprint,
  fpLine,
  fpCircle,
  fpText,
  pad
) where

import Hpcb.SExpr
import Hpcb.Data.Base
import Hpcb.Data.Layer
import Hpcb.Data.Footprint
import Hpcb.Data.FpElement
import Hpcb.Data.Effects
import Hpcb.Data.Net

footprint ::   String    -- ^ Name
            -> FpContent
            -> Footprint
footprint n fpc = Footprint n defaultLayer dummyTEdit dummyTStamp origin fpc

fpLine ::   V2 Float    -- ^ Start
            -> V2 Float -- ^ End
            -> Float    -- ^ Width
            -> FpContent
fpLine s e w = FpContent [FpLine s e defaultLayer w]

fpCircle :: V2 Float    -- ^ Center
            -> V2 Float -- ^ End
            -> Float    -- ^ Width
            -> FpContent
fpCircle c e w = FpContent [FpCircle c e defaultLayer w]

fpText :: String                -- ^ Name
          -> String             -- ^ Content
          -> Effects            -- ^ Effects (Font, justification, etc.)
          -> FpContent
fpText n c e = FpContent [FpText n c origin defaultLayer e]

pad ::  Int           -- ^ Pin number
        -> PadType
        -> PadShape
        -> Size
        -> PadDrill
        -> Net
        -> FpContent
pad n t sh si d pnet = FpContent [Pad n t sh origin si d padDefaultLayers pnet]