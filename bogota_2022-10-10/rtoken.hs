{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, OverloadedStrings #-}

import Sound.Tidal.Stream
import Sound.Tidal.Pattern
import Sound.Tidal.ParseBP
import Sound.Tidal.Stream
import Sound.Tidal.Context

rtokenTarget =
  Target {oName = "rtoken",   -- A friendly name for the target (only used in error messages)
          oAddress = "127.0.0.1", -- The target's network address, normally "localhost"
          oPort = 12345,          -- The network port the target is listening on
          oLatency = 0.35,         -- Additional delay, to smooth out network jitter/get things in sync
          oSchedule = Live,       -- The scheduling method - see below
          oWindow = Nothing,      -- Not yet used
          oHandshake = False,     -- SuperDirt specific
          oBusPort = Nothing      -- Also SuperDirt specific
         }

rtokenShape = OSC "/rtoken" $ ArgList [("x", Just $ VF 0.5),
                                 ("y", Just $ VF 0.5),
                                 ("z", Just $ VF 0),
                                 ("size", Nothing),
                                 ("speed", Just $ VF 20)
                                ]

rtokenMap = (rtokenTarget, [
   rtokenShape
  ])

x = pF "x"
y = pF "y"
z = pF "z"
-- size = pF "size"
-- speed = pF "speed"
