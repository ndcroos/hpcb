module Hpcb.Component.CapacitiveSensor (
  capacitiveSensor
) where

import Hpcb.Data.Action
import Hpcb.Data.Base
import Hpcb.Data.Circuit
import Hpcb.Data.Effects
import Hpcb.Data.FpElement
import Hpcb.Data.Layer
import Hpcb.Functions
import Data.Monoid

capacitiveSensor :: String        -- ^ Reference
                    -> Float      -- ^ Diameter on copper layer
                    -> Float      -- ^ Diameter on silk screen
                    -> Circuit
capacitiveSensor ref diam1 diam2 = footprint ref "Capacitive_Sensor" $
  fpText "reference" ref StandardEffects # translate (V2 0 (-maxDiam/2-2)) # layer FSilkS
  <> fpText "value" val StandardEffects # translate (V2 0 (maxDiam/2+2)) # layer FFab
  <> fpCircle (V2 0 0) (V2 (diam2/2+0.5) 0) # layer FSilkS # width 0.15
  <> fpCircle (V2 0 0) (V2 (maxDiam/2+1) 0) # layer FCrtYd # width 0.05
  <> pad 1 SMD Circle (V2 diam1 diam1) (newNet ref 1) # layers [FCu]
  where
    val = "Capacitive_Sensor_" ++ show diam1 ++ "mm"
    maxDiam = max diam1 diam2
