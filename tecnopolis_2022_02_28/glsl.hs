{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, OverloadedStrings #-}

import Sound.Tidal.Stream
import Sound.Tidal.Pattern
import Sound.Tidal.ParseBP
import Sound.Tidal.Stream
import Sound.Tidal.Context


scMap = ((superdirtTarget {oLatency = 0.4, oAddress = "127.0.0.1", oPort = 57120}),[superdirtShape])

glslTarget =
  Target {oName = "glsl",   -- A friendly name for the target (only used in error messages)
          oAddress = "127.0.0.1", -- The target's network address, normally "localhost"
          oPort = 8000,           -- The network port the target is listening on
          oLatency = 0.3,         -- Additional delay, to smooth out network jitter/get things in sync
          oSchedule = Live,       -- The scheduling method - see below
          oWindow = Nothing       -- Not yet used
         }

glslMap = (glslTarget, [
   OSC "/knit" $ ArgList [("cycle", Just $ VF 0),("knit", Nothing)]
  ])

knit = pF "knit"
